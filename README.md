# rpi4-k3s-cluster

Your Raspberry Pi 4 Model B based cluster


## Installation

1. Run `dmesg -w` in one terminal
1. Connect the SDCard to your computer
1. Check the device name in the kernel logs (e.g: /dev/mmcblk0 or /dev/sdc)
1. Run `sudo MMC_DEV=/dev/mmcblk0 ./flash-sdcard.sh` (triple check to
    make sure the `MMC_DEV` is set to the correct memory card device, this operation
    might cause data loss!)
1. Extract the SDCard from your computer, boot the first Raspberry Pi with the new sdcard inserted
1. Optional: once the Raspberry has booted, setup the DHCP Server on your router to always assign the same IP to your
   Raspberry Pi, or set a manual IP Address on the Raspberry Pi (e.g: 192.168.1.180).
1. Manually change the password to the Raspberry Pi by connecting via SSH
1. Add your SSH key to the Raspberry Pi (`ssh-copy-id alarm@192.168.1.180`)
1. Add the entry in `inventories/home/hosts.yml` specifying the role of the current node
1. Connect via ssh `ssh alarm@192.168.1.180` and run the following:
   ```bash
   su
   # Type the password "root"
   pacman-key --init
   pacman-key --populate archlinuxarm
   pacman -Sy --noconfirm python # For Ansible
   ```
1. Go back to step 1. and repeat the operation for each remaining node

## Setup the nodes

```bash
ansible-galaxy collection install community.general
```
