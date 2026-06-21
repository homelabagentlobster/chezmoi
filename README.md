# OpenClaw Dotfiles

OpenClaw-only dotfiles managed with chezmoi.

## Install

Install chezmoi:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)"
```

Initialize:

```sh
chezmoi init git@github.com:Oli-Ward/openclaw-dotfiles.git
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

## Managed Agent Config

This repo manages reviewed Claude config plus root/global Codex config, commands, skills, hooks, and statusline scripts.

It does not manage runtime history, session logs, sqlite state, plugin caches, attachments, worktrees, or auth files.
