#!/bin/sh
make modules_install INSTALL_MOD_PATH=$(pwd)/stage
make headers_install INSTALL_HDR_PATH=$(pwd)/stage-h
mkdir $(pwd)/stage/boot
cp arch/x86/boot/bzImage $(pwd)/stage/boot/vmlinuz-$(make -s kernelrelease)
echo "version $(make -s kernelrelease)" > stage-h/car
echo "version $(make -s kernelrelease)" >> stage/car
echo "exec kernel-switch" >> stage/car
mkdir -p stage/usr/bin
cp ../tools/kern_switch.sh stage/usr/bin/kernel-switch
