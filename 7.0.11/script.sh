#!/bin/sh
set -e

have() {
    if command -v "$1" >/dev/null 2>&1; then
        printf ' ==> %s is installed\n' "$1"
    else
        printf ' \033[91;1m==>\033[0m\033[91m %s is not installed\033[0m\n' "$1"
        exit 1
    fi
}

echo "=> Checking for dependencies"
have curl
have tar
have make
have fakeroot

echo "=> Compiling linux-stable=7.0.11"

echo " ==> Downloading https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.11.tar.xz (this may take some time)"
if [ -e linux-7.0.11.tar.xz ]; then
	echo "   => Skipped: already done."
else
	curl -# -L -o linux-7.0.11.tar.xz https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.11.tar.xz
fi

echo " ==> Extracting linux-7.0.11.tar.xz (this may take some time)"
tar -xf linux-7.0.11.tar.xz

echo " ==> Writing the configuration to linux-7.0.11/.config"
cp 7.0.11.config linux-7.0.11/.config

cd linux-7.0.11

echo " ==> Starting compilation using $(nproc) CPUs (this will take some time)"
yes "" | make -j$(nproc)

echo "=> Creating package for linux-stable=7.0.11"

echo " ==> Creating package directories"
package_headers=$(pwd)/package-headers
package=$(pwd)/package
mkdir -p $package $package_headers

echo " ==> Creating packages"

echo "   => Creating linux-stable"
echo "    ==> Copying boot files"
mkdir -p package/boot
cp arch/x86/boot/bzImage package/boot/vmlinuz-7.0.11
ln -sf vmlinuz-7.0.11 package/boot/vmlinuz
cp System.map package/boot/System.map-7.0.11
echo "    ==> Installing modules"
make modules_install INSTALL_MOD_PATH=$package
echo "    ==> Writing package metadata"
echo "version 7.0.11" > $package/car
echo "    ==> Creating package tzst in fakeroot"
fakeroot tar -I zstd -cf linux-stable.tar.zst $package/

echo "   => Creating linux-headers"
echo "    ==> Installing headers"
make headers_install INSTALL_HDR_PATH=$package_headers
echo "    ==> Writing package metadata"
echo "version 7.0.11" > $package_headers/car
echo "    ==> Creating package tzst in fakeroot"
fakeroot tar -I zstd -cf linux-stable.tar.zst $package_headers/

echo -e "=> \033[92;1mCompilation finished.\033[0m"
echo "   Output: linux-stable.tar.zst "
echo "           linux-headers.tar.zst"
