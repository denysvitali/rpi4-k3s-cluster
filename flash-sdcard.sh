#!/bin/bash

MMC_DEV=${MMC_DEV:-/dev/mmcblk0}
SKIP_TIMEOUT=${SKIP_TIMEOUT:-0}

source ./utils.sh


if [ "$UID" -ne 0 ]; then
  print_fatal "This script must be run as root"
fi

if [ ! -b "$MMC_DEV" ]; then
	echo "The selected device is not a block device";
	exit 1;
fi

# Check if device is mounted
abort_if_mounted "$MMC_DEV"

print_info "Installation will be performed on $MMC_DEV in 5 seconds, press CTRL+C now to abort"

if [ "$SKIP_TIMEOUT" -eq 1 ]; then
  print_info "Skipping timeout, as requested"
else
  for i in $(seq 1 5); do
    echo -n "."
    sleep 1
  done
  echo
fi

./steps/1-create-partitions.sh
./steps/2-format-partitions.sh
./steps/3-copy-rootfs.sh

