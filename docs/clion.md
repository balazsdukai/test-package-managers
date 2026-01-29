# CLion notes

These notes keep the workflow lightweight and reproducible inside the VM.

## General
- Install CLion inside the VM, or use remote development if you prefer to keep CLion on the host.
- Open projects from the mounted repo path inside the VM.

## nix flakes
- Enter the dev shell before launching CLion so environment variables and toolchains are visible:
  - `nix develop` in `projects/nix-flake`
- Launch CLion from that shell.

## pixi
- Activate the pixi environment before launching CLion:
  - `pixi shell` in `projects/pixi`
- Launch CLion from that shell.

## vcpkg
- Ensure `VCPKG_ROOT` is set in the environment.
- Use the provided CMake preset or set the toolchain file manually:
  - `$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake`
