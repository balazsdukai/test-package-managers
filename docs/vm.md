# VM setup notes

## Image discovery
- `multipass find` to list available images on your host.
- Update `VM_IMAGE` in `justfile` to match the image you want.

## Basic lifecycle
- `just vm-create`
- `just vm-mount`
- `just vm-provision-base`

## Optional: enable a GUI
Some Ubuntu images are server-only. If you need a desktop session:
- Install a desktop environment and set the graphical target:
  - `sudo apt-get update`
  - `sudo apt-get -y install ubuntu-desktop`
  - `sudo systemctl set-default graphical.target`
  - `sudo reboot`

GUI access methods vary by host OS; use your preferred remote desktop or console access.
