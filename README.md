# OpenClaw Dotfiles

OpenClaw-only dotfiles managed with chezmoi.

This repo is the source of truth for the OpenClaw shell bootstrap and managed
agent configuration. It is intentionally narrower than the general dotfiles repo
it came from.

## Install

Install chezmoi:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)"
```

Initialize:

```sh
chezmoi init git@github.com:homelabagentlobster/chezmoi.git
```

Preview:

```sh
chezmoi doctor
chezmoi data
chezmoi diff
```

Apply after reviewing the diff:

```sh
chezmoi apply --verbose
```

The repo defaults to the `openclaw` chezmoi profile in `.chezmoi.toml.tmpl`.
Override it only for one-off debugging with `CHEZMOI_PROFILE=openclaw`.

## What It Manages

- OpenClaw zsh config under `~/.zsh`
- Global git config and ignore rules
- Atuin, Starship, and mise config
- Linux apt bootstrap package lists for the OpenClaw host
- OpenClaw profile aliases, completion loading, and local secret sourcing
- Claude config, commands, skills, theme, hooks, and statusline
- Codex config, instructions, hooks, skills, plugins, and statusline

The bootstrap installs a small Linux package set, zinit, and mise-managed tools.
It no longer carries macOS, WSL, homelab, or personal-machine profile branches.

## Secrets

Do not commit secrets.

Keep these local:

- `~/.openclaw/secrets.env`
- SSH private keys
- `~/.codex/auth.json`
- `~/.claude/.credentials.json`
- Docker auth
- API tokens
- `.env` files

## Unmanaged Runtime State

This repo does not manage runtime history, session logs, sqlite state, plugin
caches, attachments, worktrees, generated packages, browser state, or auth files.

For changes, edit the chezmoi source files in this repo and verify before
applying:

```sh
chezmoi diff
```
