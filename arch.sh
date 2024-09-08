#!/usr/bin/env sh

# ./arch.sh /dev/nvme0n1

drive="$1"

[ -z "$drive" ] && echo "usage: $0 <drive>" && exit
[ "$EUID" -ne 0 ] && echo "must be run as root" && exit

# make sure /mnt exists
sudo mkdir /mnt 2>/dev/null

# incase there are leftovers from a previous run
sudo umount /mnt/boot 2>/dev/null
sudo umount /mnt/ 2>/dev/null
swapoff -a

# prepare the drive
parted "$drive" mklabel gpt
parted -s -a opt "$drive" mkpart myboot fat32 1MiB 261MiB
parted -s -a opt "$drive" set 1 boot on
parted -s -a opt "$drive" mkpart myswap ext4 261MiB 20GiB
parted -s -a opt "$drive" mkpart myroot ext4 20GiBMiB 100%

boot_partition="/dev/$(lsblk -l "$drive" | awk 'NR==3 {print $1}')"
swap_partition="/dev/$(lsblk -l "$drive" | awk 'NR==4 {print $1}')"
root_partition="/dev/$(lsblk -l "$drive" | awk 'NR==5 {print $1}')"

# parted seems to fail to format the drives... dunno why
mkfs.fat -F 32 "$boot_partition"
mkswap "$swap_partition"
yes | mkfs.ext4 "$root_partition"

# mount the partitions
mount "$root_partition" /mnt || exit
mkdir /mnt/boot 2>/dev/null
mount "$boot_partition" /mnt/boot || exit
swapon "$swap_partition"

# install packages
pacstrap - < pkgs.txt

# generate /etc/fstab
genfstab -U /mnt >> /mnt/etc/fstab

{
  ln -sf /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
  hwclock --systohc
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
  locale-gen
  echo "mahmooz" > /etc/hostname
  grub-install /dev/sda
  grub-mkconfig -o /boot/grub/grub.cfg
  echo root:root | chpasswd
} | arch-chroot /mnt