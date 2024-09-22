#!/usr/bin/env sh

source ./env.sh

# packages written in a file, ignore lines starting with #
list_packages_from_file() {
    grep -v '^#' "$1"
}

# ./arch.sh /dev/nvme0n1

drive="$1"

[ -z "$drive" ] && echo "usage: $0 <drive>" && exit
[ "$EUID" -ne 0 ] && echo "must be run as root" && exit

# make sure /mnt exists
mkdir /mnt 2>/dev/null

echo cleanup

# incase there are leftovers from a previous run
umount /mnt/boot 2>/dev/null
umount /mnt/ 2>/dev/null
swapoff -a

echo preparing drive

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
mkdir -p /mnt/boot/efi 2>/dev/null
mount "$boot_partition" /mnt/boot/efi || exit
swapon "$swap_partition"

echo installing packages

# install packages
pacstrap /mnt $BASE_PACKAGE_LIST

mkdir /mnt/etc/

echo entering chroot for further configuration

# generate /etc/fstab
genfstab -U /mnt >> /mnt/etc/fstab

# {
#   ln -sf /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
#   hwclock --systohc
#   echo "LANG=en_US.UTF-8" > /etc/locale.conf
#   locale-gen
#   echo "mahmooz" > /etc/hostname
#   grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=usb /dev/sda
#   grub-mkconfig -o /boot/grub/grub.cfg
#   echo root:root | chpasswd
# } | arch-chroot /mnt

arch-chroot /mnt /bin/bash -c '
  ln -sf /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
  hwclock --systohc
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
  locale-gen
  echo "mahmooz" > /etc/hostname
  grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=usb /dev/sda
  grub-mkconfig -o /boot/grub/grub.cfg
  echo root:root | chpasswd
'

echo copying scripts

cp -r /home/mahmooz/work/arch /mnt

# notice that installing the grub bootloader seems to delete the present one.. i need to either fix this by installing it on both devices or keep it as a task that is done manually
