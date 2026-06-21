alias zshconfig="code ~/.zsh"
alias zshrc="code ~/.zshrc"
alias reload="source ~/.zshrc"

alias gc="git commit"  # OMZ gc is --verbose; work-wsl overrides with gitmoji
alias glog="git log --oneline --graph --decorate --all"  # OMZ gl=git pull

# On Debian/Ubuntu fd ships as fdfind.
(( ${+commands[fdfind]} )) && alias fd="fdfind"

if (( ${+commands[eza]} )); then
  alias tree="eza --tree --icons"  # OMZ eza plugin handles ls/la/ll via zstyles
fi

if [[ "$DOTFILES_OS" == "macos" ]]; then
  alias buou="brew update && brew outdated && brew upgrade && brew cleanup"
fi

starship-test() {

  local config="${1:-test-starship.toml}"

  STARSHIP_CONFIG_OVERRIDE="$(chezmoi source-path)/dot_config/starship/$config" zsh

}

starship-default() {

  unset STARSHIP_CONFIG_OVERRIDE

  exec zsh

}

alias dcb="docker compose build"
alias dcd="docker compose down"
alias dcu="docker compose up -d"
alias dcbud="docker compose build && docker compose up -d"
alias dcbu="docker compose build && docker compose up"
alias dcdbud="docker compose down && docker compose build && docker compose up -d"
