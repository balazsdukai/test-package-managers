#!/usr/bin/env bash
set -euo pipefail

if command -v nix >/dev/null 2>&1; then
  echo "nix already installed"
  exit 0
fi

curl -L https://nixos.org/nix/install | sh -s -- --daemon

# Enable flakes + nix-command for nix develop.
sudo mkdir -p /etc/nix
if ! sudo grep -Eq '^experimental-features\s*=.*\b(nix-command)\b' /etc/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf >/dev/null
fi

cat <<'MSG'

nix installed.
- Open a new shell or source the profile to pick up nix.
- For flakes, ensure experimental features are enabled in nix.conf if needed.
MSG
