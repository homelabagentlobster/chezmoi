#!/usr/bin/env bash
set -euo pipefail

PREINSTALL_DIR="${PREINSTALL_DIR:?PREINSTALL_DIR is not set}"

YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

managed_file="$tmp_dir/managed-packages.txt"
installed_file="$tmp_dir/installed-packages.txt"

collect_managed_packages() {
  local manager="$1"
  local package_dir="$PREINSTALL_DIR/packages/$manager"

  if [[ ! -d "$package_dir" ]]; then
    return 0
  fi

  find "$package_dir" -type f -name '*.txt' -print0 \
    | xargs -0 cat \
    | sed 's/#.*$//' \
    | sed '/^[[:space:]]*$/d' \
    | sed 's/^[[:space:]]*//' \
    | sed 's/[[:space:]]*$//' \
    | sort -u
}

print_undeclared() {
  local label="$1"
  local count=0

  echo -e "\n${BOLD}${label}${NC}"

  while IFS= read -r pkg; do
    printf "  ${YELLOW}?${NC} %s\n" "$pkg"
    (( count++ )) || true
  done

  echo -e "\n${BOLD}Summary:${NC} ${count} undeclared package(s)"
  if (( count > 0 )); then
    echo "Add them to the relevant packages list or uninstall if no longer needed"
  fi
}

audit_apt() {
  if ! command -v apt-mark >/dev/null 2>&1; then
    return 0
  fi

  collect_managed_packages apt > "$managed_file"
  apt-mark showmanual | sort -u > "$installed_file"

  comm -23 "$installed_file" "$managed_file" | print_undeclared "apt — manually installed but not in preinstall lists"
}

audit_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    return 0
  fi

  collect_managed_packages brew > "$managed_file"

  # brew leaves = explicitly installed formulae that are not dependencies of other installed formulae
  brew leaves | sort -u > "$installed_file"

  comm -23 "$installed_file" "$managed_file" | print_undeclared "brew — manually installed but not in preinstall lists"
}

case "$(uname -s)" in
  Linux)
    audit_apt
    ;;
  Darwin)
    audit_brew
    ;;
  *)
    echo "No package audit configured for $(uname -s)"
    ;;
esac
