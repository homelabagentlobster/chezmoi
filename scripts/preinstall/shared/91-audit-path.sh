#!/usr/bin/env bash
set -euo pipefail

PREINSTALL_DIR="${PREINSTALL_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
RUNTIMES_FILE="$PREINSTALL_DIR/runtimes.txt"

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

owner_for_path() {
  local path="$1"

  case "$path" in
    "$HOME/.local/share/mise/"*|"$HOME/.local/share/mise/shims/"*)
      echo "mise"
      ;;
    "$HOME/.nvm/"*)
      echo "nvm"
      ;;
    /mnt/c/*)
      echo "windows"
      ;;
    /opt/homebrew/*)
      echo "brew"
      ;;
    /usr/bin/*|/usr/local/bin/*)
      echo "system"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

color_for_owner() {
  case "$1" in
    mise)    echo "$GREEN" ;;
    nvm)     echo "$YELLOW" ;;
    windows) echo "$YELLOW" ;;
    system)  echo "$NC" ;;
    *)       echo "$RED" ;;
  esac
}

echo -e "\n${BOLD}Runtime/tool audit${NC}\n"
printf '%-10s %-12s %-50s %s\n' "command" "owner" "path" "version"
printf '%-10s %-12s %-50s %s\n' "-------" "-----" "----" "-------"

found=0
missing=0

while IFS= read -r cmd || [[ -n "$cmd" ]]; do
  [[ -z "$cmd" || "$cmd" == \#* ]] && continue
  if command -v "$cmd" >/dev/null 2>&1; then
    path="$(command -v "$cmd")"
    owner="$(owner_for_path "$path")"
    color="$(color_for_owner "$owner")"
    version="$("$cmd" --version 2>&1 | head -1 || true)"
    printf "${color}%-10s %-12s %-50s %s${NC}\n" "$cmd" "$owner" "$path" "$version"
    (( found++ )) || true
  else
    printf "${RED}%-10s %-12s${NC}\n" "$cmd" "not found"
    (( missing++ )) || true
  fi
done < "$RUNTIMES_FILE"

echo ""
echo -e "${BOLD}Summary:${NC} ${GREEN}${found} found${NC}, ${RED}${missing} not found${NC}"

if command -v mise >/dev/null 2>&1; then
  echo -e "\n${BOLD}mise current${NC}"
  mise current || true
fi
