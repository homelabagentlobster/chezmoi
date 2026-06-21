#!/usr/bin/env bash
set -euo pipefail

list_file="${1:?Usage: install-list.sh <package-list.txt>}"

missing=()

while IFS= read -r pkg || [[ -n "$pkg" ]]; do
  [[ -z "$pkg" || "$pkg" == \#* ]] && continue
  if ! dpkg -s "$pkg" >/dev/null 2>&1; then
    missing+=("$pkg")
  fi
done < "$list_file"

if (( ${#missing[@]} == 0 )); then
  echo "All packages from $(basename "$list_file") already installed"
  exit 0
fi

if ! command -v sudo >/dev/null 2>&1 || ! sudo -n true >/dev/null 2>&1; then
  echo "Missing packages from $(basename "$list_file"): ${missing[*]}"
  echo "Skipping apt install; sudo is unavailable or cannot elevate without a password."
  exit 0
fi

echo "Installing: ${missing[*]}"
sudo apt-get update -qq
sudo apt-get install -y "${missing[@]}"
