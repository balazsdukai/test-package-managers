# Package Manager VM Testbed

A small, repeatable project scaffold for testing C++ workflows with nix flakes, pixi, and vcpkg inside isolated Multipass VMs running Ubuntu (GUI optional).

## Goals
- Spin up disposable Ubuntu VMs with Multipass.
- Install and compare nix flakes, pixi, and vcpkg for C++ builds.
- Test CLion integration in a clean, reproducible environment.
- Use `just` as the task runner for common operations.

## Prerequisites
- Multipass installed and working on your host.
- An Ubuntu image available in Multipass (confirm with `multipass find`).
- `just` installed on the host.

## Quick start
1. Review `justfile` variables at the top and adjust VM name, image, CPU/RAM/disk, and `VM_USER` (the username inside the VM).
2. Create the VM:
   - `just vm-create` (or `just vm-create vm=your-vm-name`)
3. Mount this repo into the VM:
   - `just vm-mount` (or `just vm-mount vm=your-vm-name`)
4. Provision base build tools inside the VM:
   - `just vm-provision-base` (or `just vm-provision-base vm=your-vm-name`)
5. Install the package managers you want:
   - `just vm-install-nix` (or `just vm-install-nix vm=your-vm-name`)
   - `just vm-install-pixi` (or `just vm-install-pixi vm=your-vm-name`)
   - `just vm-install-vcpkg` (or `just vm-install-vcpkg vm=your-vm-name`)

Project samples live in `projects/`.

## Structure
- `justfile` - Task runner for VM lifecycle and provisioning.
- `vm/` - VM templates and notes.
- `scripts/` - Provisioning scripts to run inside the VM.
- `projects/` - Minimal C++ sample projects for each package manager.
- `docs/` - Notes for CLion setup and workflow ideas.

## Notes
- Multipass Ubuntu images and GUI access differ by host OS and image availability. Adjust the VM image and access method to your environment.
- CLion installation is intentionally manual; see `docs/clion.md` for guidance.
