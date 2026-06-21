#!/usr/bin/env bash
# Audits declared package lists against what is actually installed.
# Run from anywhere: bash <(chezmoi source-path)/scripts/audit-packages.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREINSTALL_DIR="$SCRIPT_DIR/preinstall"

GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

installed=0
missing=0

check_apt() { dpkg -s "$1" >/dev/null 2>&1; }
check_brew() { brew list --formula "$1" >/dev/null 2>&1; }

audit_list() {
  local file="$1"
  local check_fn="$2"

  echo -e "\n${BOLD}$(basename "$file")${NC}"

  while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    [[ -z "$pkg" || "$pkg" == \#* ]] && continue
    if "$check_fn" "$pkg" 2>/dev/null; then
      printf "  ${GREEN}✓${NC} %s\n" "$pkg"
      (( installed++ )) || true
    else
      printf "  ${RED}✗${NC} %s\n" "$pkg"
      (( missing++ )) || true
    fi
  done < "$file"
}

case "$(uname -s)" in
  Linux)
    if ! command -v dpkg >/dev/null 2>&1; then
      echo "dpkg not found; cannot audit apt packages"
      exit 1
    fi
    for f in "$PREINSTALL_DIR"/packages/apt/*.txt; do
      [[ -f "$f" ]] && audit_list "$f" check_apt
    done
    ;;
  Darwin)
    if ! command -v brew >/dev/null 2>&1; then
      echo "brew not found; cannot audit brew packages"
      exit 1
    fi
    for f in "$PREINSTALL_DIR"/packages/brew/*.txt; do
      [[ -f "$f" ]] && audit_list "$f" check_brew
    done
    ;;
  *)
    echo "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac

echo ""
echo -e "${BOLD}Summary:${NC} ${GREEN}${installed} installed${NC}, ${RED}${missing} missing${NC}"
(( missing > 0 )) && echo "Run: chezmoi apply  (or the preinstall script) to install missing packages"
exit $(( missing > 0 ? 1 : 0 ))
