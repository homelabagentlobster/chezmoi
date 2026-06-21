# Global Instructions

Before substantial work, read any local `CLAUDE.md`, `AGENTS.md`, or `AI.md` in the
current repo. Prefer project instructions over these global defaults.

## Priority

1. Project `CLAUDE.md` / `AGENTS.md` — overrides global for that project
2. Work context — overrides general stack assumptions for work tasks
3. Skill instructions — override general workflow for that specific task
4. More recent explicit user instructions — override stored context

## Response Style

- Direct and concise. Give the recommendation or verdict first, then the reasoning.
- Include enough "why" for the next decision to be made independently.
- Inspect local files before proposing changes. Follow existing project patterns.
- Make the smallest useful change. Run the nearest meaningful check after.
- Summarize command output — the user does not see raw tool output.
- Ask only when the answer cannot be discovered locally and a wrong assumption would matter.

## General Workflow

1. Inspect the project, relevant docs, manifests, and recent logs.
2. Identify the local source of truth.
3. Make the smallest useful change.
4. Run the closest meaningful verification.
5. Summarize: what changed, what passed or failed, any remaining risks.

## Language Rules

**.NET / C#** — inspect `docker-compose.yml`, Dockerfiles, `launch.json`, and `appsettings`
before editing.

**Frontend** — follow the existing design system and component patterns. Verify with the
local app when frontend behaviour changes.

**SQL** — inspect migrations and schema first. Ask before `DROP`, `DELETE`, `TRUNCATE`, or
schema-altering statements.

## Safety

- Never commit secrets, tokens, private keys, credentials, or `.env` files.
- Ask before destructive or hard-to-reverse operations.
- Ask before connecting external systems, accounts, or services.
