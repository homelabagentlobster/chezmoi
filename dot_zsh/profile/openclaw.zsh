# OpenClaw profile

# OpenClaw low-power VM settings
export NODE_COMPILE_CACHE="${NODE_COMPILE_CACHE:-/var/tmp/openclaw-compile-cache}"
export OPENCLAW_NO_RESPAWN="${OPENCLAW_NO_RESPAWN:-1}"
export QMD_FORCE_CPU="${QMD_FORCE_CPU:-1}"

# OpenClaw secrets
if [[ -f "$HOME/.openclaw/secrets.env" ]]; then
  source "$HOME/.openclaw/secrets.env"
fi

# Linuxbrew, when present on the host
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Linux convenience aliases
if command -v xdg-open >/dev/null 2>&1; then
  alias open="xdg-open"
fi

# OpenClaw service helpers
alias openclaw-start='rbw unlock && bash ~/.openclaw/workspace/execution/openclaw-start.sh'
alias openclaw-restart='/home/openclaw/.openclaw/workspace/tools/bin/openclaw-restart'
alias openclaw-stop='/home/openclaw/.openclaw/workspace/tools/bin/openclaw-stop'
alias openclaw-status='/home/openclaw/.openclaw/workspace/tools/bin/openclaw-status'
alias openclaw-with-secrets='/home/openclaw/.openclaw/workspace/tools/bin/openclaw-with-secrets'
alias openclaw-doctor='/home/openclaw/.openclaw/workspace/tools/bin/openclaw-doctor'

# Reuse the available Bash completion when no native zsh completion exists.
if [[ -f "$HOME/.openclaw/completions/openclaw.bash" ]]; then
  autoload -Uz bashcompinit
  bashcompinit
  source "$HOME/.openclaw/completions/openclaw.bash"
fi
