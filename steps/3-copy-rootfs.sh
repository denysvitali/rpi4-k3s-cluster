#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/../utils.sh"

TARBALL_FILE=${TARBALL_FILE:-}
TARBALL_DOWNLOADED_NAME=alpine-rpi-3.14.3-aarch64.tar.gz
TARBALL_URL="https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/aarch64/alpine-rpi-3.14.3-aarch64.tar.gz"
TMP_DIR=$(mktemp -d)

HEADLESS_APKOVL_FILE=${HEADLESS_APKOVL_FILE:-alpine/headless.apkovl.tar.gz}
HEADLESS_APKOVL_NAME="headless.apkovl.tar.gz"

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

if [ -z "$HEADLESS_APKOVL_FILE" ]; then
  wget "$HEADLESS_APKOVL_URL" -O "$TMP_DIR/$HEADLESS_APKOVL_NAME"
  HEADLESS_APKOVL_FILE="$TMP_DIR/$HEADLESS_APKOVL_NAME"
fi

mkdir "$TMP_DIR/extracted/"
tar \
  --no-same-owner \
  -xvzf "$TARBALL_FILE" \
  -C "/mnt/$BOOT_DEVICE_DIR"
cp "$HEADLESS_APKOVL_FILE" "/mnt/$BOOT_DEVICE_DIR/$HEADLESS_APKOVL_NAME"
sync

umount "/mnt/$BOOT_DEVICE_DIR" || true
umount "/mnt/$ROOTFS_DEVICE_DIR" || true
rmdir "/mnt/$BOOT_DEVICE_DIR"
rmdir "/mnt/$ROOTFS_DEVICE_DIR"
