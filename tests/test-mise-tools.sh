#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tools_file="$repo_root/dot_config/mise/config.toml.tmpl"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

assert_tool_declared() {
  local tool="$1"

  if ! grep -Eq "^${tool}[[:space:]]*=" "$tools_file"; then
    fail "expected mise tool to be declared: $tool"
  fi
}

assert_tool_declared fd
assert_tool_declared fzf
assert_tool_declared zoxide
