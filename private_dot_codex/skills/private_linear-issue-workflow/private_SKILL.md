---
name: linear-issue-workflow
description: Use when picking up, starting, implementing, finishing, blocking, or updating a Linear issue through Codex, including bare numeric OPN ticket references, ticket identifiers, Linear status transitions, issue plans, commits, pushes, or final ticket updates.
---

# Linear Issue Workflow

## Overview

Run a Linear issue as the source of truth from intake to handoff. Keep the issue state, implementation plan, Git history, and final Linear update consistent.

**Core rule:** do not start implementation before the issue has a written Superpowers plan and the Linear issue is moved to an active state.

## Required Sub-Skills

- **REQUIRED:** Use `linear:linear` for Linear reads and updates.
- **REQUIRED:** Use `superpowers:writing-plans` after reading the issue and before implementation.
- **REQUIRED:** Use `superpowers:verification-before-completion` before marking the issue done.
- **IF BUG OR TEST FAILURE:** Use `superpowers:systematic-debugging` before proposing fixes.
- **IF IMPLEMENTING CODE:** Use `superpowers:test-driven-development` unless the user explicitly opts out.

## Workflow

1. Resolve the issue.
   - If the user gives an identifier, fetch that issue.
   - In this workspace, bare numeric ticket references always mean `OPN-<number>`; for example, `ticket 61` resolves to `OPN-61`.
   - If the user says to pick one up, list assigned or relevant issues and choose the highest-priority actionable issue using the user's filters.
   - Read the title, identifier, description, comments, state, labels, project, branch/PR links, and acceptance criteria.
   - If the issue is ambiguous or lacks enough implementation detail, ask for the smallest missing decision before changing status.

2. Create the Superpowers plan.
   - Base the plan on Linear content, not memory.
   - Include scope, files/modules likely to change, tests/verification, Linear status checkpoints, and expected final update.
   - Save the plan using the active Superpowers planning convention.
   - Do not move to implementation until the plan exists.

3. Move Linear to active work.
   - Set the issue to `In Progress` or the workspace's equivalent active state before code changes.
   - If status names are unknown, inspect available states or use the closest state type that clearly means active work. Do not guess terminal states.
   - Add a short comment only if useful: plan written, work starting, and the plan path.

4. Implement from the plan.
   - Keep work scoped to the issue and plan.
   - Preserve unrelated user changes in the worktree.
   - Run the planned tests and any focused checks needed for touched behavior.
   - If the work cannot proceed, stop and prepare a blocked update rather than forcing a partial finish.

5. Commit and push.
   - In `/home/openclaw/.openclaw/workspace`, default to committing completed issue work on `dev`; do not create a branch per Linear issue.
   - Keep `main` as last known good and promote with a `dev` -> `main` PR when requested.
   - Create a disposable Linear-key branch only when the user explicitly asks or the task is high-risk enough to require isolation.
   - Prefix disposable branch names and commit subjects with the Linear identifier when creating them.
   - Commit subject format: `<ISSUE-ID>: <imperative summary>` (example: `OPN-18: add price monitor email intake`).
   - Push only with explicit user approval.
   - If the repo already has a branch or commit policy, follow it while preserving the issue identifier prefix.

6. Finish or block the issue.
   - Done path: after verification passes, move Linear to `Done` or the workspace's equivalent completed state.
   - Blocked path: if blocked by missing access, missing requirements, failing external systems, or an unresolved dependency, move Linear to `Blocked` or the workspace's equivalent blocked state.
   - If no explicit blocked state exists, leave the issue active and add a blocking comment with the exact reason and next required owner/action.

## Final Linear Update

Use a comment for the normal final update. Update the description only when the durable issue record changed, such as acceptance criteria, implementation notes the team expects in the body, or a discovered scope correction.

The final comment should include:

- Outcome: done or blocked.
- What changed or what stopped progress.
- Verification run and result, including commands when available.
- Commit hash, branch, and PR link if present.
- Remaining follow-ups, or `None`.

For blocked work, include the exact blocker, evidence, attempted steps, and the next action needed to unblock. Do not mark an issue blocked just because the task is hard, tests are failing, or more investigation is needed.

## Status Guardrails

- Never move an issue to `Done` before verification has run and passed, unless the user explicitly says to mark administrative/non-code work complete.
- Never hide partial work behind a `Done` status. If the implementation is incomplete, use active or blocked status and explain what remains.
- Prefer comments for chronological progress. Prefer description edits for durable requirements or issue-body corrections.
- Keep Git and Linear identifiers aligned where the workflow has those fields. In the OpenClaw workspace, routine work may use long-lived `dev`, so preserve the issue identifier in commit subjects, PR titles, and final comments even when there is no per-issue branch.
