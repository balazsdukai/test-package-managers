#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install \
  git \
  curl \
  ca-certificates \
  cmake \
  ninja-build \
  build-essential \
  gdb \
  pkg-config \
  unzip \
  tar
