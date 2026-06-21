---
name: chezmoi-dotfiles
description: Use for chezmoi-managed dotfiles, shell config, Git/SSH templates, Starship, aliases, editor settings, and profile-specific setup. Do not use for ordinary project config not managed by chezmoi, app feature work, or one-off shell advice unrelated to dotfiles.
---

# Chezmoi Dotfiles

## When to use

Use this skill for chezmoi-managed dotfiles, shell config, Git/SSH templates, Starship, aliases, editor settings, and profile-specific setup.

## When not to use

Do not use this skill for ordinary project config that is not managed by chezmoi, app feature work, or one-off shell advice unrelated to dotfiles.

## Inputs to inspect first

- Chezmoi source directory.
- Local chezmoi config.
- Active profile data.
- Relevant source templates under the chezmoi source tree.
- Existing generated target paths only for comparison.

## Safe commands

- `chezmoi doctor`
- `chezmoi status`
- `chezmoi diff`
- `chezmoi managed`
- `chezmoi source-path <target>`

## Unsafe / ask first

- `chezmoi apply`
- `chezmoi apply --force`
- Editing generated target files instead of source templates.
- Changing SSH, Git identity, work profile, or credential-related files.
- Removing managed files or changing profile-selection logic.

## Expected output

- A concise diagnosis or scoped dotfiles change plan.
- Source-file edits only, with generated target impact explained.
- Verification from `chezmoi diff` before any apply step.
- Clear note of active profile and affected target paths.

## Known failure modes

- Editing generated files and losing changes on the next apply.
- Mixing shared config with profile-specific config.
- Accidentally exposing secrets, private keys, tokens, `.env` files, or work credentials.
- Applying broad changes before reviewing the diff.
