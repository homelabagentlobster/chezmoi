# Basic shell environment.
export LANG="${LANG:-en_US.UTF-8}"

# Blocking editor for Git and other CLI tools that wait for an edit to finish.
export CLI_BLOCKING_EDITOR="${CLI_BLOCKING_EDITOR:-code --wait}"
export EDITOR="$CLI_BLOCKING_EDITOR"
export VISUAL="$CLI_BLOCKING_EDITOR"

# Safer history defaults.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt extended_history
setopt hist_expire_dups_first
setopt hist_verify