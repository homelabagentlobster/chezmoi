#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$repo_root/scripts/preinstall/packages/apt/install-list.sh"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"

  [[ "$haystack" == *"$needle"* ]] || fail "expected output to contain: $needle"
}

run_with_stubs() {
  local case_name="$1"
  local sudo_mode="$2"
  local tmpdir list_file stub_dir output status

  tmpdir="$(mktemp -d)"
  stub_dir="$tmpdir/bin"
  mkdir -p "$stub_dir"
  list_file="$tmpdir/packages.txt"
  printf 'zsh\nripgrep\n' > "$list_file"

  cat > "$stub_dir/dpkg" <<'STUB'
#!/bin/bash
exit 1
STUB
  chmod +x "$stub_dir/dpkg"

  cat > "$stub_dir/apt-get" <<'STUB'
#!/bin/bash
echo "apt-get should not run" >&2
exit 42
STUB
  chmod +x "$stub_dir/apt-get"

  cat > "$stub_dir/basename" <<'STUB'
#!/bin/bash
printf '%s\n' "${1##*/}"
STUB
  chmod +x "$stub_dir/basename"

  if [[ "$sudo_mode" == "denied" ]]; then
    cat > "$stub_dir/sudo" <<'STUB'
#!/bin/bash
echo "sudo denied" >&2
exit 1
STUB
    chmod +x "$stub_dir/sudo"
  fi

  set +e
  output="$(PATH="$stub_dir" /bin/bash "$script" "$list_file" 2>&1)"
  status=$?
  set -e

  /usr/bin/rm -rf "$tmpdir"

  [[ "$status" -eq 0 ]] || fail "$case_name exited with $status; output: $output"
  assert_contains "$output" "Missing packages from packages.txt: zsh ripgrep"
  assert_contains "$output" "Skipping apt install"
}

run_with_stubs "no sudo available" "missing"
run_with_stubs "sudo cannot elevate" "denied"
