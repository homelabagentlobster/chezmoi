---
name: mssql-debugging
description: Use for SQL Server connection, query, migration, schema, timeout, pooling, or local/dev data issues. Do not use for non-SQL Server databases, destructive data fixes, production changes without explicit approval, or app bugs where the database is not involved.
---

# MSSQL Debugging

## When to use

Use this skill for SQL Server connection, query, migration, schema, timeout, pooling, or local/dev data issues.

## When not to use

Do not use this skill for non-SQL Server databases, destructive data fixes, production database changes without explicit approval, or application bugs where the database is not involved.

## Inputs to inspect first

- App configuration and connection-string source.
- Docker Compose or SQL Server host/container details.
- Migration files and schema definitions.
- Query code, repository/data-access layer, and logs.
- Error messages, timeout details, and authentication mode.

## Safe commands

- Read-only `SELECT` queries.
- Schema inspection queries.
- `docker compose ps`
- `docker compose logs <sql-service>`
- App-level test commands that do not mutate data.

## Unsafe / ask first

- `DROP`, `DELETE`, `TRUNCATE`, `UPDATE`, `MERGE`, or schema-changing SQL.
- Running migrations.
- Resetting databases or deleting volumes.
- Exposing or copying credentials.
- Connecting to work or production databases.

## Expected output

- A concise diagnosis separating connectivity, authentication, schema, data, timeout, and pooling causes.
- Non-destructive checks first.
- Exact commands or SQL snippets with sensitive values redacted.
- Clear ask-first boundary before any data or schema mutation.

## Known failure modes

- Local and container hostnames differ.
- Integrated auth behaves differently across macOS, Windows, WSL, and containers.
- Connection strings come from multiple config layers.
- Timeouts mask slow queries, locks, or missing indexes.
- Work database details leaking into global context or logs.
