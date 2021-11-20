#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/../utils.sh"

set -e
set -x
ls "$BOOT_DEVICE" > /dev/null
ls "$ROOTFS_DEVICE" > /dev/null
set +e

abort_if_mounted "$BOOT_DEVICE"
abort_if_mounted "$ROOTFS_DEVICE"

BOOT_DEVICE_DIR=$(basename "$BOOT_DEVICE")
ROOTFS_DEVICE_DIR=$(basename "$ROOTFS_DEVICE")

set -e
set -x
mkdir "/mnt/$BOOT_DEVICE_DIR"
mkdir "/mnt/$ROOTFS_DEVICE_DIR"
mkfs.fat -F32 "$BOOT_DEVICE"
mkfs.ext4 "$ROOTFS_DEVICE"
mount "$BOOT_DEVICE" "/mnt/$BOOT_DEVICE_DIR"
