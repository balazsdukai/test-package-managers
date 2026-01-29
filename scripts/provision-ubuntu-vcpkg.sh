#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

bash "${script_dir}/provision-ubuntu.sh"

sudo apt-get -y install \
  zip \
  gfortran \
  autoconf \
  automake \
  libtool \
  m4
