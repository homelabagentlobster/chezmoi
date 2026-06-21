#!/usr/bin/env bash
set -euo pipefail

CHEZMOI_SOURCE_DIR="${CHEZMOI_SOURCE_DIR:?CHEZMOI_SOURCE_DIR is not set}"

YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

total_unmanaged=0

# Convert chezmoi source filename to target filename.
# dot_foo.zsh -> .foo.zsh; anything without dot_ prefix -> unchanged.
source_to_target_name() {
  local name="$1"
  if [[ "$name" == dot_* ]]; then
    echo ".${name#dot_}"
  else
    echo "$name"
  fi
}

check_dir() {
  local target_dir="${1/\~/$HOME}"
  local source_dir="$CHEZMOI_SOURCE_DIR/$2"

  [[ -d "$target_dir" ]] || return 0
  [[ -d "$source_dir" ]] || return 0

  local -a expected=()
  local f base
  while IFS= read -r f; do
    base="$(basename "$f")"
    expected+=("$(source_to_target_name "$base")")
  done < <(find "$source_dir" -maxdepth 1 -type f | sort)

  local count=0
  while IFS= read -r f; do
    base="$(basename "$f")"
    local found=0
    local exp
    for exp in ${expected[@]+"${expected[@]}"}; do
      [[ "$exp" == "$base" ]] && found=1 && break
    done
    if (( !found )); then
      (( count == 0 )) && echo -e "\n${BOLD}${target_dir} — not managed by chezmoi${NC}"
      printf "  ${YELLOW}?${NC} %s\n" "$base"
      (( count++ )) || true
    fi
  done < <(find "$target_dir" -maxdepth 1 -type f | sort)

  if (( count > 0 )); then
    echo "  Delete or add to chezmoi: chezmoi add <file>"
    (( total_unmanaged += count )) || true
  fi
}

echo -e "\n${BOLD}Unmanaged file audit${NC}"

check_dir "~/.zsh/shared"      "dot_zsh/shared"
check_dir "~/.zsh/profile"     "dot_zsh/profile"
check_dir "~/.config/starship" "dot_config/starship"

echo ""
if (( total_unmanaged > 0 )); then
  printf "${BOLD}Summary:${NC} %d unmanaged file(s) found\n" "$total_unmanaged"
else
  echo -e "${BOLD}Summary:${NC} all checked directories are clean"
fi
