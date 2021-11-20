#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/../utils.sh"

TARBALL_FILE=${TARBALL_FILE:-}
TARBALL_DOWNLOADED_NAME=ArchLinuxARM-rpi-aarch64-latest.tar.gz
TARBALL_URL="http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz"
TMP_DIR=$(mktemp -d)

set -x

function cleanup_dirs(){
  rm -rf "$TMP_DIR"
}

trap "cleanup_dirs" SIGINT
trap "cleanup_dirs" ERR EXIT


if [ -z "$TARBALL_FILE" ]; then
  wget "$TARBALL_URL" -O "$TMP_DIR/$TARBALL_DOWNLOADED_NAME"
  TARBALL_FILE="$TMP_DIR/$TARBALL_DOWNLOADED_NAME"
fi

mkdir "$TMP_DIR/extracted/"
bsdtar -xpf "$TARBALL_FILE" -C "$TMP_DIR/extracted/"

ls "$TMP_DIR/extracted"
mv "$TMP_DIR/extracted/"* "/mnt/$ROOTFS_DEVICE_DIR/"
mv "/mnt/$ROOTFS_DEVICE_DIR/boot/"* "/mnt/$BOOT_DEVICE_DIR/"
sync

sed -i 's/mmcblk0/mmcblk1/g' "/mnt/$ROOTFS_DEVICE_DIR/etc/fstab"

umount "/mnt/$ROOTFS_DEVICE_DIR"
umount "/mnt/$BOOT_DEVICE_DIR"

rmdir "/mnt/$ROOTFS_DEVICE_DIR"
rmdir "/mnt/$BOOT_DEVICE_DIR"
