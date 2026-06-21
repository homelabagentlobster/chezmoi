# Cross-platform tools.

# zoxid
if command -v zoxide >/dev/null 2>&1; then
  unalias zi 2>/dev/null
  unfunction zi 2>/dev/null
  eval "$(zoxide init zsh)"
fi
# Starship
# Priority: profile-specific > OS-specific > default
STARSHIP_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/starship"

STARSHIP_DEFAULT_CONFIG="$STARSHIP_DIR/default.toml"
STARSHIP_OS_CONFIG="$STARSHIP_DIR/${DOTFILES_OS}.toml"
STARSHIP_PROFILE_CONFIG="$STARSHIP_DIR/${PROFILE}.toml"

if [[ -n "$STARSHIP_CONFIG_OVERRIDE" && -s "$STARSHIP_CONFIG_OVERRIDE" ]]; then
  export STARSHIP_CONFIG="$STARSHIP_CONFIG_OVERRIDE"
elif [[ -s "$STARSHIP_PROFILE_CONFIG" ]]; then
  export STARSHIP_CONFIG="$STARSHIP_PROFILE_CONFIG"
elif [[ -s "$STARSHIP_OS_CONFIG" ]]; then
  export STARSHIP_CONFIG="$STARSHIP_OS_CONFIG"
elif [[ -s "$STARSHIP_DEFAULT_CONFIG" ]]; then
  export STARSHIP_CONFIG="$STARSHIP_DEFAULT_CONFIG"
else
  unset STARSHIP_CONFIG
fi

if (( ${+commands[starship]} )); then
  eval "$(starship init zsh)"

  # JetBrains' JediTerm (Rider/IDEA terminal) mis-renders right-aligned prompts,
  # so clear RPROMPT after starship sets it. Appended last so it runs after
  # starship's own precmd hook.
  if [[ "$TERMINAL_EMULATOR" == JetBrains-JediTerm ]]; then
    _clear_rprompt() { RPROMPT='' }
    precmd_functions+=(_clear_rprompt)
  fi
fi

# fzf shell integration: key-bindings (^R history, ^T files, alt-c cd) + completion.
# fzf's completion rebinds Tab, so restore fzf-tab afterwards.
if (( ${+commands[fzf]} )); then
  source <(fzf --zsh)
  (( ${+functions[enable-fzf-tab]} )) && enable-fzf-tab
fi

# local bin env
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
