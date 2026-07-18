#!/bin/sh
make modules_install INSTALL_MOD_PATH=$(pwd)/stage
make headers_install INSTALL_HDR_PATH=$(pwd)/stage-h
mkdir $(pwd)/stage/boot
cp arch/x86/boot/bzImage $(pwd)/stage/boot/vmlinuz-$(make -s kernelrelease)
