#!/usr/bin/env bash
set -euo pipefail

if command -v pixi >/dev/null 2>&1; then
  echo "pixi already installed"
  exit 0
fi

curl -fsSL https://pixi.sh/install.sh | bash

# Ensure non-interactive login shells can find pixi
pixi_path_line='export PATH="$HOME/.pixi/bin:$PATH"'
for profile_file in "$HOME/.profile" "$HOME/.bashrc"; do
  if ! grep -Fqx "$pixi_path_line" "$profile_file" 2>/dev/null; then
    echo "$pixi_path_line" >> "$profile_file"
  fi
done

cat <<'MSG'

pixi installed.
- Open a new shell or source your profile to pick up pixi in PATH.
MSG
