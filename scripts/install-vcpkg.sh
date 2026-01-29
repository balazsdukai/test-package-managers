#!/usr/bin/env bash
set -euo pipefail

VCPKG_ROOT="${VCPKG_ROOT:-$HOME/vcpkg}"

if [ ! -d "$VCPKG_ROOT" ]; then
  git clone https://github.com/microsoft/vcpkg.git "$VCPKG_ROOT"
fi

"$VCPKG_ROOT/bootstrap-vcpkg.sh"

cat <<MSG

vcpkg installed at: $VCPKG_ROOT
- Consider adding to your profile:
  export VCPKG_ROOT="$VCPKG_ROOT"
  export PATH="$VCPKG_ROOT:$PATH"
MSG
