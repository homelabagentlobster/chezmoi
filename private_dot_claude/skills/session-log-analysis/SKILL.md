---
name: session-log-analysis
description: Use to mine AI session logs, chat exports, or findings for repeated context, durable preferences, corrections, recurring commands, and reusable project facts. Do not use for live emotional support, private diary-style summarization, project implementation, or copying raw transcripts into global context.
---

# Session Log Analysis

## When to use

Use this skill to mine AI session logs, chat exports, or findings for repeated context, durable preferences, corrections, recurring commands, and reusable project facts.

## When not to use

Do not use this skill for live emotional support, private diary-style summarization, project implementation, or copying raw transcripts into global context.

## Inputs to inspect first

- Export README or manifest.
- Relevant conversations, session logs, or findings.
- Existing `context/` files.
- Existing project `AGENTS.md`, `AI.md`, or findings files.
- Any source-priority notes or contradiction reports.

## Safe commands

- Read-only search with `rg`.
- Read-only file inspection.
- Scripts that audit or summarize exports without modifying source files.
- Local JSON inspection that does not upload content.

## Unsafe / ask first

- Publishing, syncing, or uploading raw exports.
- Adding sensitive personal, contact, credential, medical, recovery, or work-private details to global context.
- Treating old exports as more authoritative than current project files or direct user corrections.
- Bulk rewriting context without a source map.

## Expected output

- Candidate facts grouped by destination.
- Stable facts promoted only to the smallest relevant context file.
- Project-specific facts routed to project docs or findings.
- Contradictions and stale facts flagged instead of silently resolved.
- Sensitive or volatile content excluded.

## Known failure modes

- Overfitting global context to one old conversation.
- Duplicating the same fact across many files.
- Promoting stale job-search, location, or work details.
- Preserving too much raw emotional or personal content.
- Losing source traceability for imported facts.
