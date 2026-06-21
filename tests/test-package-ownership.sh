#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

assert_not_listed() {
  local package="$1"
  local file="$2"

  if grep -Eq "^${package}$" "$file"; then
    fail "expected $package to be managed outside apt, but found it in ${file#$repo_root/}"
  fi
}

assert_listed() {
  local package="$1"
  local file="$2"

  if ! grep -Eq "^${package}$" "$file"; then
    fail "expected $package in ${file#$repo_root/}"
  fi
}

assert_not_listed fzf "$repo_root/scripts/preinstall/packages/apt/10-base.txt"
assert_not_listed zoxide "$repo_root/scripts/preinstall/packages/apt/20-shell-tools.txt"
assert_not_listed fd-find "$repo_root/scripts/preinstall/packages/apt/20-shell-tools.txt"
assert_not_listed keychain "$repo_root/scripts/preinstall/packages/apt/20-shell-tools.txt"

assert_listed keychain "$repo_root/scripts/preinstall/packages/brew/20-shell-tools.txt"
assert_listed keychain "$repo_root/scripts/preinstall/packages/brew/30-linux-user-tools.txt"

if ! grep -Fq 'packages/brew/30-linux-user-tools.txt' "$repo_root/scripts/preinstall/shared/10-packages.sh"; then
  fail "expected Linux preinstall to route no-sudo Homebrew user tools"
fi
