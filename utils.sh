#!/bin/bash

function print_err(){
  echo "$1" > /dev/stderr
}

function print_fatal(){
  echo "[FATAL] $1" > /dev/stderr
  exit 1
}

function print_info(){
  echo "[INFO] $1"
}

function abort_if_mounted(){
  if [ "$(mount | grep -c "$1")" -gt 0 ]; then
    print_fatal "Filesystem is already mounted. Double check that this is the right file system ($1), " \
      "unmount it and try again."
  fi
}

MMC_DEV=${MMC_DEV:-/dev/mmcblk0}

if echo "$MMC_DEV" | grep -q "^/dev/mmcblk"; then
  BOOT_DEVICE="${MMC_DEV}p1"
  ROOTFS_DEVICE="${MMC_DEV}p2"
else
  BOOT_DEVICE="${MMC_DEV}1"
  ROOTFS_DEVICE="${MMC_DEV}2"
fi

BOOT_DEVICE_DIR=$(basename "$BOOT_DEVICE")
ROOTFS_DEVICE_DIR=$(basename "$ROOTFS_DEVICE")
