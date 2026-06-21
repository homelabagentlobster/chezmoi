---
name: docker-dotnet-debugging
description: Use for .NET apps running in Docker Compose, Dev Containers, VS Code/Cursor debugging, container startup failures, and debugger attach workflows. Do not use for non-containerized .NET issues, production incident response, Kubernetes-only debugging, or database-only problems better handled by the mssql-debugging skill.
---

# Docker .NET Debugging

## When to use

Use this skill for .NET apps running in Docker Compose, Dev Containers, VS Code/Cursor debugging, container startup failures, and debugger attach workflows.

## When not to use

Do not use this skill for non-containerized .NET issues, production incident response, Kubernetes-only debugging, or database-only problems better handled by the MSSQL skill.

## Inputs to inspect first

- `docker-compose.yml` and compose override files.
- Dockerfiles.
- `.devcontainer/` configuration.
- `.vscode/launch.json` and `.vscode/tasks.json`.
- `.csproj`, appsettings, environment files, and service entrypoints.
- Current container/service names, ports, working directories, and build configuration.

## Safe commands

- `docker compose config`
- `docker compose ps`
- `docker compose logs <service>`
- `docker compose build <service>`
- `dotnet --info`
- `dotnet build`

## Unsafe / ask first

- `docker compose down -v`
- Removing volumes, images, or containers.
- Changing bind mounts, exposed ports, or container users.
- Installing debugging tools inside containers.
- Editing secrets, connection strings, or work environment files.

## Expected output

- A step-by-step diagnosis that separates container startup, build, path mapping, symbol loading, and debugger attach issues.
- Minimal config changes with exact files and affected services.
- Verification commands and summarized results.
- Clear explanation for grey breakpoints or missed debugger attaches.

## Known failure modes

- Debug symbols missing because the app is built in Release mode.
- Source path mismatch between host, Dev Container, and running container.
- Compose override files changing the effective runtime config.
- Breakpoints binding to stale binaries.
- Windows/PowerShell paths differing from Linux container paths.
