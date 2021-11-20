#!/bin/bash

MMC_DEV=${MMC_DEV:-/dev/mmcblk0}
SKIP_TIMEOUT=${SKIP_TIMEOUT:-0}

source ./utils.sh

if [ ! -b "$MMC_DEV" ]; then
	echo "The selected device is not a block device";
	exit 1;
fi

# Never flash a mounted device
if mount | grep "^$MMC_DEV"; then
  print_fatal "A partition of $MMC_DEV is mounted. Stopping!"
  exit 1
fi

# Get disk name
BASENAME=$(basename "$MMC_DEV")

if [ ! -f "/sys/class/block/$BASENAME/removable" ]; then
  print_fatal "Invalid device $MMC_DEV"
  exit 1
fi

# Never flash a non-removable device!
IS_REMOVABLE=$(cat "/sys/class/block/$BASENAME/removable")
if [ "$IS_REMOVABLE" -ne "1" ]; then
  print_fatal "Device $MMC_DEV is not marked as removable!"
  exit 1
fi



if [ "$UID" -ne 0 ]; then
  print_fatal "This script must be run as root"
fi

# Check if device is mounted
abort_if_mounted "$MMC_DEV"

print_info "Installation will be performed on $MMC_DEV in 5 seconds, press CTRL+C now to abort"

if [ "$SKIP_TIMEOUT" -eq 1 ]; then
  print_info "Skipping timeout, as requested"
else
  for _ in $(seq 1 5); do
    echo -n "."
    sleep 1
  done
  echo
fi

./steps/1-create-partitions.sh
./steps/2-format-partitions.sh
./steps/3-copy-rootfs.sh

