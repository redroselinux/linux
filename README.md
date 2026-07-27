# Linux package source

This repository contains files for the Linux kernel packages (configs). Currently, it includes these kernel versions:
- `7.0.11`
- `7.1.4`

It also contains some tooling for compilation in `tools/`:
- `mkstage.sh` - create stage dirs `stage` and `stage-h` for kernel headers, expects `tools/` in `../tools/`
- `mkpkg.sh` - create car pkgs `linux-stable.tar.zst` and `linux-headers.tar.zst`, then print sha256sums
- `kern_switch.sh` - switch the file that `/boot/vmlinuz` is a symlink to
