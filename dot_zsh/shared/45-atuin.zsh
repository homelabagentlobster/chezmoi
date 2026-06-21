# Atuin: richer shell history search (command, exit code, duration, cwd, session).
#
# Loaded after 40-tools.zsh on purpose: fzf binds Ctrl+R there, so Atuin must
# init last to own the keybind (Option A). Up-arrow is left as plain zsh history.

if ! command -v atuin >/dev/null 2>&1; then
  return
fi

eval "$(atuin init zsh --disable-up-arrow)"

# Explicit guarantee that Ctrl+R opens Atuin, regardless of init defaults or
# any later plugin. Up-arrow stays bound to normal zsh history.
bindkey '^R' atuin-search

