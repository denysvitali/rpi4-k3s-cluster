#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/../utils.sh"

abort_if_mounted "$MMC_DEV"
print_info "Creating partition table for $MMC_DEV"

echo "o
p
n
p
1

+200M
p
t
c
n
p
2


p
w" | fdisk "$MMC_DEV"
