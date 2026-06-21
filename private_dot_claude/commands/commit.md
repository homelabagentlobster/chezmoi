Review the current git diff and staged changes, then suggest a commit message.

Rules:
- Use gitmoji format: <emoji> <message>
- Keep the subject line under 72 characters
- If a ticket number is visible in the branch name or surrounding context, prefix it: TICKET-#### <emoji> <message>
- Do not commit automatically unless explicitly asked
- Flag any risky, unrelated, or sensitive changes before suggesting the message
- If nothing is staged, say so and suggest what to stage
