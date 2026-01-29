set dotenv-load := true
set shell := ["bash", "-uc"]

ROOT := justfile_directory()
VM_NAME := "pkgtest-ubuntu"
VM_IMAGE := "24.04"
VM_CPUS := "4"
VM_MEM := "6G"
VM_DISK := "30G"
VM_USER := "ubuntu"
VM_MOUNT_NAME := "workspace"
VM_MOUNT_PATH := "/home/" + VM_USER + "/" + VM_MOUNT_NAME

# Show available tasks
help:
  @just --list

# VM lifecycle
vm-create vm=VM_NAME:
  multipass launch --name {{vm}} --cpus {{VM_CPUS}} --memory {{VM_MEM}} --disk {{VM_DISK}} --cloud-init {{ROOT}}/vm/cloud-init.yaml {{VM_IMAGE}}

vm-delete vm=VM_NAME:
  multipass delete --purge {{vm}}

vm-start vm=VM_NAME:
  multipass start {{vm}}

vm-stop vm=VM_NAME:
  multipass stop {{vm}}

vm-info vm=VM_NAME:
  multipass info {{vm}}

vm-shell vm=VM_NAME:
  multipass shell {{vm}}

# Mount/unmount repo into the VM
vm-mount vm=VM_NAME:
  multipass mount {{ROOT}} {{vm}}:{{VM_MOUNT_PATH}}

vm-unmount vm=VM_NAME:
  multipass unmount {{vm}}:{{VM_MOUNT_PATH}}

# Provisioning
vm-provision-base vm=VM_NAME:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}} && bash scripts/provision-ubuntu.sh"

vm-install-nix vm=VM_NAME:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}} && bash scripts/install-nix.sh"

vm-install-pixi vm=VM_NAME:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}} && bash scripts/install-pixi.sh"

vm-install-vcpkg vm=VM_NAME:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}} && bash scripts/install-vcpkg.sh"

# Build samples
build-nix vm=VM_NAME:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}}/projects/nix-flake && nix develop -c bash -lc \"cmake -S . -B build -G Ninja && cmake --build build\""

build-pixi vm=VM_NAME:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}}/projects/pixi && pixi run configure && pixi run build"

build-vcpkg vm=VM_NAME:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}}/projects/vcpkg && export VCPKG_ROOT=${VCPKG_ROOT:-$HOME/vcpkg} && cmake --preset vcpkg && cmake --build build"
