set dotenv-load := true
set shell := ["bash", "-uc"]

ROOT := justfile_directory()
VM_NAME := "pkgtest-ubuntu"
VM_NAME_NIX := "pkgtest-nix"
VM_NAME_PIXI := "pkgtest-pixi"
VM_NAME_VCPKG := "pkgtest-vcpkg"
VM_IMAGE := "24.04"
VM_CPUS := "4"
VM_MEM := "6G"
VM_DISK := "30G"
VM_USER := "ubuntu"
VM_MOUNT_NAME := "workspace"
VM_MOUNT_PATH := "/home/" + VM_USER + "/" + VM_MOUNT_NAME
VM_VCPKG_ROOT := "/home/" + VM_USER + "/vcpkg"

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

# Multi-VM helpers
vm-create-all:
  @just vm-create {{VM_NAME_NIX}}
  @just vm-create {{VM_NAME_PIXI}}
  @just vm-create {{VM_NAME_VCPKG}}

vm-delete-all:
  @just vm-delete {{VM_NAME_NIX}}
  @just vm-delete {{VM_NAME_PIXI}}
  @just vm-delete {{VM_NAME_VCPKG}}

vm-start-all:
  @just vm-start {{VM_NAME_NIX}}
  @just vm-start {{VM_NAME_PIXI}}
  @just vm-start {{VM_NAME_VCPKG}}

vm-stop-all:
  @just vm-stop {{VM_NAME_NIX}}
  @just vm-stop {{VM_NAME_PIXI}}
  @just vm-stop {{VM_NAME_VCPKG}}

# Mount/unmount repo into the VM
vm-mount vm=VM_NAME:
  multipass mount {{ROOT}} {{vm}}:{{VM_MOUNT_PATH}}

vm-unmount vm=VM_NAME:
  multipass unmount {{vm}}:{{VM_MOUNT_PATH}}

vm-mount-all:
  @just vm-mount {{VM_NAME_NIX}}
  @just vm-mount {{VM_NAME_PIXI}}
  @just vm-mount {{VM_NAME_VCPKG}}

vm-unmount-all:
  @just vm-unmount {{VM_NAME_NIX}}
  @just vm-unmount {{VM_NAME_PIXI}}
  @just vm-unmount {{VM_NAME_VCPKG}}

# Provisioning
vm-provision-base vm=VM_NAME:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}} && bash scripts/provision-ubuntu.sh"

vm-install-nix vm=VM_NAME_NIX:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}} && bash scripts/install-nix.sh"

vm-install-pixi vm=VM_NAME_PIXI:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}} && bash scripts/install-pixi.sh"

vm-install-vcpkg vm=VM_NAME_VCPKG:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}} && export VCPKG_ROOT={{VM_VCPKG_ROOT}} && bash scripts/install-vcpkg.sh"

vm-provision-all:
  @just vm-provision-base {{VM_NAME_NIX}}
  @just vm-provision-base {{VM_NAME_PIXI}}
  @just vm-provision-base {{VM_NAME_VCPKG}}

vm-install-all:
  @just vm-install-nix
  @just vm-install-pixi
  @just vm-install-vcpkg

# Build samples
build-nix vm=VM_NAME_NIX:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}}/projects/nix-flake && nix develop -c bash -lc \"cmake -S . -B build -G Ninja && cmake --build build\""

build-pixi vm=VM_NAME_PIXI:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}}/projects/pixi && pixi run configure && pixi run build"

build-vcpkg vm=VM_NAME_VCPKG:
  multipass exec {{vm}} -- bash -lc "cd {{VM_MOUNT_PATH}}/projects/vcpkg && export VCPKG_ROOT={{VM_VCPKG_ROOT}} && cmake --preset vcpkg && cmake --build build"

vm-build-all:
  @just build-nix
  @just build-pixi
  @just build-vcpkg

vm-reset-all:
  @just vm-delete-all || true
  @just vm-create-all
  @just vm-mount-all
  @just vm-provision-all
  @just vm-install-all
