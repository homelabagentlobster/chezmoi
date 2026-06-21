#!/usr/bin/env sh
set -eu

# Dracula palette (ANSI 24-bit where possible, falling back gracefully)
# These match the Starship work-wsl.toml palette exactly.
PURPLE='\033[38;2;106;0;255m'    # #6a00ff
PINK='\033[38;2;255;0;144m'      # #ff0090
CYAN='\033[38;2;0;208;255m'      # #00d0ff
COMMENT='\033[38;2;98;114;164m'  # #6272a4
GREEN='\033[38;2;80;250;123m'    # #50fa7b
YELLOW='\033[38;2;241;250;140m'  # #f1fa8c
ORANGE='\033[38;2;255;184;108m'  # #ffb86c (Dracula orange)
RED='\033[38;2;255;85;85m'       # #ff5555
TEXT='\033[38;2;255;255;255m'    # #ffffff
DIM='\033[2m'
RESET='\033[0m'

input="$(cat)"

# Parse JSON using python3 (jq is not available)
get_json() {
  printf '%s' "$input" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    keys = '$1'.lstrip('.').split('.')
    val = data
    for k in keys:
        if isinstance(val, dict):
            val = val.get(k)
        else:
            val = None
        if val is None:
            break
    if val is not None and val != '':
        print(val)
except Exception:
    pass
" 2>/dev/null || true
}

make_bar() {
  pct="${1:-0}"
  width=8
  filled=$(awk -v p="$pct" -v w="$width" 'BEGIN { printf "%.0f", p * w / 100 }')
  i=0
  bar=""
  while [ "$i" -lt "$filled" ]; do
    bar="${bar}█"
    i=$(( i + 1 ))
  done
  while [ "$i" -lt "$width" ]; do
    bar="${bar}░"
    i=$(( i + 1 ))
  done
  printf "%s" "$bar"
}

time_left() {
  reset_ts="${1:-}"
  [ -z "$reset_ts" ] && printf "?" && return
  now="$(date +%s)"
  left=$(( reset_ts - now ))
  [ "$left" -le 0 ] && printf "now" && return
  days=$(( left / 86400 ))
  hours=$(( (left % 86400) / 3600 ))
  mins=$(( (left % 3600) / 60 ))
  if [ "$days" -gt 0 ]; then
    printf "%dd %dh" "$days" "$hours"
  elif [ "$hours" -gt 0 ]; then
    printf "%dh %dm" "$hours" "$mins"
  else
    printf "%dm" "$mins"
  fi
}

sep() {
  printf ' %b│%b ' "$COMMENT" "$RESET"
}

# --- Pull data from JSON ---
model="$(get_json '.model.display_name')"
context_used="$(get_json '.context_window.used_percentage')"
context_left="$(get_json '.context_window.remaining_percentage')"
context_total_input="$(get_json '.context_window.total_input_tokens')"
rate_5h_used="$(get_json '.rate_limits.five_hour.used_percentage')"
rate_5h_reset="$(get_json '.rate_limits.five_hour.resets_at')"
rate_7d_used="$(get_json '.rate_limits.seven_day.used_percentage')"
rate_7d_reset="$(get_json '.rate_limits.seven_day.resets_at')"
current_dir="$(get_json '.workspace.current_dir')"

# Codex status payloads use primary/secondary rate-limit windows and may wrap
# token data under payload.info. Keep Claude's field names as the first choice.
[ -z "$context_total_input" ] && context_total_input="$(get_json '.info.total_token_usage.input_tokens')"
[ -z "$context_total_input" ] && context_total_input="$(get_json '.payload.info.total_token_usage.input_tokens')"
if [ -z "$context_used" ]; then
  context_input_for_pct="$context_total_input"
  context_window_for_pct="$(get_json '.info.model_context_window')"
  [ -z "$context_window_for_pct" ] && context_window_for_pct="$(get_json '.payload.info.model_context_window')"
  if [ -n "$context_input_for_pct" ] && [ -n "$context_window_for_pct" ] && [ "$context_window_for_pct" != "0" ]; then
    context_used="$(awk -v used="$context_input_for_pct" -v total="$context_window_for_pct" 'BEGIN { printf "%.0f", used * 100 / total }')"
  fi
fi
[ -z "$rate_5h_used" ] && rate_5h_used="$(get_json '.rate_limits.primary.used_percent')"
[ -z "$rate_5h_used" ] && rate_5h_used="$(get_json '.payload.rate_limits.primary.used_percent')"
[ -z "$rate_5h_reset" ] && rate_5h_reset="$(get_json '.rate_limits.primary.resets_at')"
[ -z "$rate_5h_reset" ] && rate_5h_reset="$(get_json '.payload.rate_limits.primary.resets_at')"
[ -z "$rate_7d_used" ] && rate_7d_used="$(get_json '.rate_limits.secondary.used_percent')"
[ -z "$rate_7d_used" ] && rate_7d_used="$(get_json '.payload.rate_limits.secondary.used_percent')"
[ -z "$rate_7d_reset" ] && rate_7d_reset="$(get_json '.rate_limits.secondary.resets_at')"
[ -z "$rate_7d_reset" ] && rate_7d_reset="$(get_json '.payload.rate_limits.secondary.resets_at')"
# worktree sessions: prefer the worktree path as the working dir
worktree_path="$(get_json '.worktree.path')"
[ -n "$worktree_path" ] && current_dir="$worktree_path"

# Condense model name: first letter of family + version (e.g. "Claude Sonnet 4.6" → "S4.6")
[ -z "$model" ] && model="Claude"
model="$(printf '%s' "$model" | awk '{
  initial=""; version=""
  for(i=1;i<=NF;i++) {
    if ($i ~ /^[0-9]/) version=$i
    else if ($i != "Claude") initial=substr($i,1,1)
  }
  print (initial != "" ? initial : "C") (version != "" ? version : "")
}')"
[ -z "$context_used" ] && context_used="0"
[ -z "$context_left" ] && context_left="$(awk -v u="$context_used" 'BEGIN { printf "%.0f", 100 - u }')"
[ -z "$rate_5h_used" ] && rate_5h_used="0"
[ -z "$rate_7d_used" ] && rate_7d_used="0"

# Format token count as Nk or N
if [ -n "$context_total_input" ] && [ "$context_total_input" != "0" ]; then
  token_label="$(awk -v t="$context_total_input" 'BEGIN { if (t >= 1000) printf "%.0fk", t/1000; else printf "%d", t }')"
else
  token_label=""
fi

# --- colour_for_used: pick colour based on used percentage ---
colour_for_used() {
  used_pct="${1:-0}"
  if awk -v u="$used_pct" 'BEGIN { exit !(u >= 75) }'; then
    printf '%b' "$RED"
  elif awk -v u="$used_pct" 'BEGIN { exit !(u >= 50) }'; then
    printf '%b' "$ORANGE"
  elif awk -v u="$used_pct" 'BEGIN { exit !(u >= 25) }'; then
    printf '%b' "$YELLOW"
  else
    printf '%b' "$GREEN"
  fi
}

# --- Username segment (purple, like Starship OS/user segment) ---
# 󰌽 = Linux Nerd Font icon (U+F033D)
user_seg="󰌽 $(whoami)"

# --- Directory segment (cyan, like Starship directory) ---
# = folder icon / Starship truncation_symbol (U+E5FF)
if [ -n "$current_dir" ]; then
  home_dir="$HOME"
  # Replace $HOME prefix with ~
  display_dir="$(printf '%s' "$current_dir" | sed "s|^$home_dir|~|")"
  # Truncate: keep last 2 path components (matches Starship truncation_length=2)
  display_dir="$(printf '%s' "$display_dir" | awk -F/ '{ n=NF; if (n<=2) print $0; else print $(n-1) "/" $n }')"
else
  display_dir="?"
fi

# --- Git segment (pink, like Starship git_branch/git_status) ---
git_branch=""
git_status_str=""
if [ -n "$current_dir" ] && git -C "$current_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch="$(git -C "$current_dir" branch --show-current 2>/dev/null || true)"
  [ -z "$git_branch" ] && git_branch="$(git -C "$current_dir" rev-parse --short HEAD 2>/dev/null || echo "detached")"

  staged="$(git -C "$current_dir" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')"
  modified="$(git -C "$current_dir" diff --numstat 2>/dev/null | wc -l | tr -d ' ')"
  untracked="$(git -C "$current_dir" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')"

  #  = staged (U+EADC),  = modified (U+EA73), 󰡯 = untracked (U+F086F)
  [ "$staged" -gt 0 ]    && git_status_str="${git_status_str}  ${staged}"
  [ "$modified" -gt 0 ]  && git_status_str="${git_status_str}  ${modified}"
  [ "$untracked" -gt 0 ] && git_status_str="${git_status_str} 󰡯 ${untracked}"
fi

# --- Context window segment ---
# Bar is drawn against used percentage; colour based on used percentage
ctx_used_pct="$(awk -v n="$context_used" 'BEGIN { printf "%.0f", n }')"
ctx_bar="$(make_bar "$ctx_used_pct")"
ctx_color="$(colour_for_used "$ctx_used_pct")"

if [ -n "$token_label" ]; then
  token_str=" ${token_label}"
else
  token_str=""
fi

# --- Rate limit segments (only shown when data available) ---
rate_seg=""
if [ "$(awk -v r="$rate_5h_used" 'BEGIN { print (r > 0) }')" = "1" ]; then
  rate_used_pct="$(awk -v u="$rate_5h_used" 'BEGIN { printf "%.0f", u }')"
  rate_bar="$(make_bar "$rate_used_pct")"
  time_remaining="$(time_left "$rate_5h_reset")"
  rate_color="$(colour_for_used "$rate_used_pct")"
  rate_seg="$(printf '%b%s %s%%%s %b%s%b' "$rate_color" "$rate_bar" "$rate_used_pct" "$token_str" "$COMMENT" "$time_remaining" "$RESET")"
fi

rate_7d_seg=""
if [ "$(awk -v r="$rate_7d_used" 'BEGIN { print (r > 0) }')" = "1" ]; then
  rate_7d_used_pct="$(awk -v u="$rate_7d_used" 'BEGIN { printf "%.0f", u }')"
  rate_7d_bar="$(make_bar "$rate_7d_used_pct")"
  time_7d_remaining="$(time_left "$rate_7d_reset")"
  rate_7d_color="$(colour_for_used "$rate_7d_used_pct")"
  rate_7d_seg="$(printf '%b%s %s%% %b%s%b' "$rate_7d_color" "$rate_7d_bar" "$rate_7d_used_pct" "$COMMENT" "$time_7d_remaining" "$RESET")"
fi

# --- Assemble the line ---
# All segments separated by consistent dim-grey │ dividers.

# Segment 1: directory (cyan) with folder icon  (U+E5FF)
printf '%b  %s%b' "$CYAN" "$display_dir" "$RESET"

# Segment 2: git branch + status (pink) with  branch icon (U+F418)
if [ -n "$git_branch" ]; then
  sep
  printf '%b  %s%s%b' "$PINK" "$git_branch" "$git_status_str" "$RESET"
fi

# Segment 3: context window — 󰻭 icon + bar + pct, all in ctx_color
sep
printf '%b󰻭 %s %s%%%b' "$ctx_color" "$ctx_bar" "$ctx_used_pct" "$RESET"

# Segment 4: model name in white
sep
printf '%b%s%b' "$TEXT" "$model" "$RESET"

# Segment 5: 5h rate limit (only when data available) — 󱐋 lightning icon (U+F140B)
if [ -n "$rate_seg" ]; then
  sep
  printf '%b󱐋 %s' "$rate_color" "$rate_seg"
fi

# Segment 6: 7-day rate limit (only when data available) — 󰃮 calendar icon (U+F00EE)
if [ -n "$rate_7d_seg" ]; then
  sep
  printf '%b󰃮 %s' "$rate_7d_color" "$rate_7d_seg"
fi

printf '\n'
