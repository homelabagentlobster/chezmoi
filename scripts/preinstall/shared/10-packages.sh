#!/usr/bin/env bash
set -euo pipefail

PREINSTALL_DIR="${PREINSTALL_DIR:?PREINSTALL_DIR is not set}"

case "$(uname -s)" in
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      bash "$PREINSTALL_DIR/packages/apt/install-list.sh" "$PREINSTALL_DIR/packages/apt/10-base.txt"
      bash "$PREINSTALL_DIR/packages/apt/install-list.sh" "$PREINSTALL_DIR/packages/apt/20-shell-tools.txt"
    else
      echo "No supported Linux package manager found"
    fi
    ;;
  *)
    echo "Unsupported OS for OpenClaw preinstall: $(uname -s)"
    ;;
esac
