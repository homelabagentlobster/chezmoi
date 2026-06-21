Preview and apply pending chezmoi changes.

Steps:
1. Run `chezmoi diff` and summarize what would change (which files, what kind of change)
2. Flag anything unexpected or risky
3. Pause and ask the user to confirm (e.g. reply "apply" or "yes") before proceeding
4. If confirmed, run `chezmoi apply --verbose`
5. Report what was applied and note any errors
