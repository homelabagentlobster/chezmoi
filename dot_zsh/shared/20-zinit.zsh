ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

[[ -d "$ZINIT_HOME" ]] || return

source "$ZINIT_HOME/zinit.zsh"

zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes

zinit snippet OMZ::plugins/docker/docker.plugin.zsh # Docker CLI completions (Desktop installs these).
zinit snippet OMZ::plugins/eza/eza.plugin.zsh # eza is a modern replacement for ls with more features and better defaults.
zinit snippet OMZ::plugins/git/git.plugin.zsh # Git plugin with many aliases and functions for working with git repositories.
zinit snippet OMZL::directories.zsh # provides .. & take

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Docker CLI completions (Desktop installs these).
if [[ -d "$HOME/.docker/completions" ]]; then
  fpath=("$HOME/.docker/completions" $fpath)
fi