#!/usr/bin/env bash
set -euo pipefail

if command -v pixi >/dev/null 2>&1; then
  echo "pixi already installed"
  exit 0
fi

curl -fsSL https://pixi.sh/install.sh | bash

cat <<'MSG'

pixi installed.
- Open a new shell or source your profile to pick up pixi in PATH.
MSG
