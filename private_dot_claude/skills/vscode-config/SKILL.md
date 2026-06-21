---
name: vscode-config
description: Use for VS Code or Cursor settings, tasks, launch configs, extensions, file associations, Dev Containers, and workspace editor behavior. Do not use for unrelated application code, global dotfiles managed by chezmoi, IDEs other than VS Code/Cursor, or debugger issues dominated by Docker/.NET runtime behavior.
---

# VS Code Config

## When to use

Use this skill for VS Code or Cursor settings, tasks, launch configs, extensions, file associations, Dev Containers, and workspace editor behavior.

## When not to use

Do not use this skill for unrelated application code, global dotfiles managed by chezmoi, IDEs other than VS Code/Cursor, or debugger issues dominated by Docker/.NET runtime behavior.

## Inputs to inspect first

- Workspace `.vscode/settings.json`.
- `.vscode/tasks.json`.
- `.vscode/launch.json`.
- `.devcontainer/` configuration.
- Relevant package/build manifests.
- Existing user/workspace boundary notes.

## Safe commands

- Read-only inspection of `.vscode/` and manifests.
- `code --list-extensions` when available and needed.
- Project build/test commands used only to verify settings.
- JSON validation or formatting checks that do not rewrite files.

## Unsafe / ask first

- Changing user-level settings.
- Installing or uninstalling extensions.
- Rewriting generated config.
- Changing debugger attach configs for work services without confirmation.
- Storing secrets, tokens, or machine-private paths in repo config.

## Expected output

- Minimal, readable workspace config changes.
- Clear placement choice: user setting, workspace setting, repo template, or chezmoi-managed dotfile.
- Verified commands and paths for tasks and launch configs.
- Explanation of any setting that affects the whole workspace.

## Known failure modes

- Putting personal machine paths into shared repo config.
- Confusing VS Code user settings with workspace settings.
- JSON comments/trailing commas breaking consumers outside VS Code.
- Duplicating settings already managed by chezmoi.
- Tasks or launch configs drifting from actual repo commands.
