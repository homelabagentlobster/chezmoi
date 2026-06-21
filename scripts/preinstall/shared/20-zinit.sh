#!/usr/bin/env bash
set -euo pipefail

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ -d "$ZINIT_HOME" ]]; then
  echo "zinit already installed"
  exit 0
fi

echo "Installing zinit..."
mkdir -p "$(dirname "$ZINIT_HOME")"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
