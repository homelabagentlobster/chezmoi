# Main zsh config loader.

export ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-$HOME/.zsh}"

if [[ -n "${ZSH_PROFILE_STARTUP:-}" ]]; then
  zmodload zsh/datetime
  zmodload zsh/zprof
fi

_zsh_source() {
  local file="$1"
  if [[ -n "${ZSH_PROFILE_STARTUP:-}" ]]; then
    local start elapsed
    start=$EPOCHREALTIME
    source "$file"
    elapsed=$(( (EPOCHREALTIME - start) * 1000 ))
    printf '[zsh timing] %7.2f ms  %s\n' "$elapsed" "${file/#$HOME/~}"
  else
    source "$file"
  fi
}

# Detect OS/environment.
case "$(uname -s)" in
  Linux)
    export DOTFILES_OS="linux"
    ;;
  *)
    export DOTFILES_OS="unknown"
    ;;
esac

# Load shared config in predictable order.
for config in "$ZSH_CONFIG_DIR"/shared/[0-9][0-9]-*.zsh; do
  [[ -f "$config" ]] && _zsh_source "$config"
done

# Load profile (set by chezmoi template, or fall back to OpenClaw).
[[ -f "$ZSH_CONFIG_DIR/profile.sh" ]] && _zsh_source "$ZSH_CONFIG_DIR/profile.sh"

if [[ -z "${PROFILE:-}" ]]; then
  PROFILE="openclaw"
fi
export PROFILE

# Load profile-specific config.
[[ -f "$ZSH_CONFIG_DIR/profile/${PROFILE}.zsh" ]] && _zsh_source "$ZSH_CONFIG_DIR/profile/${PROFILE}.zsh"

# Load optional private config. Do not commit this.
[[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && _zsh_source "$ZSH_CONFIG_DIR/local.zsh"

if [[ -n "${ZSH_PROFILE_STARTUP:-}" ]]; then
  echo
  zprof
fi

# Keep the home loader from treating an absent optional file as a load failure.
true
