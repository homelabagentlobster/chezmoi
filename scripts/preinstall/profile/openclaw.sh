#!/usr/bin/env bash
set -euo pipefail

# Install mise if not already available
if ! command -v mise >/dev/null 2>&1 && [[ ! -x "$HOME/.local/bin/mise" ]]; then
  echo "Installing mise..."
  curl https://mise.run | sh
else
  echo "mise already installed"
fi
