---
name: ticket-primer
description: Use when starting work on a POR Jira ticket — accepts POR-XXXX, a bare number, or prompts if no arg supplied. Fetches the ticket, assigns to user, transitions to In Progress, and creates a git branch from origin/incubator.
---

# Ticket Primer

## Overview
Start-of-work ritual for a POR Jira ticket: claim ownership, move to In Progress, and create a correctly-named feature branch from the incubator base.

## Steps (execute in order)

### 1. Resolve the ticket number
Accept any of these formats and normalise to `POR-XXXX`:
- `POR-1234` → use as-is
- `1234` → prefix to `POR-1234`
- no args → use `AskUserQuestion` to prompt for the ticket number, then normalise

- Cloud ID: `4993bca1-5fc9-4ddb-8a5d-b25cf4dc7cbc` (clevermedkits.atlassian.net)

Use `mcp__claude_ai_Atlassian_Rovo__getJiraIssue` to fetch the issue. Capture:
- `summary` — used to generate the branch name
- `assignee.accountId` — to check ownership
- `status.name` — to check if already in progress

### 2. Assign to self (if needed)
- User account ID: `712020:8f86c281-516d-4587-86f6-7922ba2b5b07` (Oli Ward)
- If `assignee` is null **or** the account ID does not match — assign with `mcp__claude_ai_Atlassian_Rovo__editJiraIssue`
- If already assigned to the user — skip silently

### 3. Transition to In Progress (if needed)
- If `status.name` is not `In Progress`:
  - Use transition ID `11` ("In Progress") directly with `mcp__claude_ai_Atlassian_Rovo__transitionJiraIssue`
  - If that fails, fall back to `mcp__claude_ai_Atlassian_Rovo__getTransitionsForJiraIssue` to find the correct ID
- If already In Progress — skip silently

### 4. Generate branch name
Slugify the issue summary:
1. Lowercase the summary
2. Replace any character that is not `a-z`, `0-9`, or `-` with a hyphen
3. Collapse consecutive hyphens into one
4. Trim leading/trailing hyphens
5. Truncate to 50 characters at a word (hyphen) boundary — do not cut mid-word
6. Prefix with the ticket number: `POR-XXXX-<slug>`

### 5. Confirm or edit branch name
Use `AskUserQuestion` to show the proposed branch name and ask the user to confirm or provide an alternative. Present a single question with the proposed name as the default option and an "Other" path for edits.

### 6. Create the branch
```bash
git fetch origin incubator
git checkout -b <confirmed-branch-name> origin/incubator
```

If the branch already exists locally, report it to the user — do not force-checkout.

## Jira tools reference

| Action | Tool |
|--------|------|
| Fetch issue | `mcp__claude_ai_Atlassian_Rovo__getJiraIssue` |
| Assign issue | `mcp__claude_ai_Atlassian_Rovo__editJiraIssue` |
| Apply transition | `mcp__claude_ai_Atlassian_Rovo__transitionJiraIssue` |
| List transitions (fallback) | `mcp__claude_ai_Atlassian_Rovo__getTransitionsForJiraIssue` |
| Look up account ID | `mcp__claude_ai_Atlassian_Rovo__lookupJiraAccountId` |

## Summary to show the user on completion

After all steps complete, print a short summary:
- Ticket: `POR-XXXX — <summary>`
- Assigned to: self (or "already assigned")
- Status: In Progress (or "already in progress")
- Branch: `<branch-name>` (created from `origin/incubator`)

## Common issues

- **No "In Progress" transition visible** — check all transition names from `getTransitionsForJiraIssue`; the name varies by board config
- **Branch already exists locally** — report to user, do not checkout; suggest `git checkout <branch-name>` instead
