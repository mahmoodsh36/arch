#!/usr/bin/env sh

source ./env.sh

# packages written in a file, ignore lines starting with #
list_packages_from_file() {
    grep -v '^#' "$1"
}

# install packages
list_packages_from_file ~/work/arch/pkgs.txt | sudo pacman --needed --noconfirm -S -

setup_yay() {
    yay --version && return 1
    mkdir -p ~/.cache/yay/ 2>/dev/null
    cd ~/.cache/yay/
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    # cd ..
    # rm -rf yay
}

# install aur packages
setup_yay
# yay apparently doesnt auto resolve conflicts even with --noconfirm, so we use 'yes'
# list_packages_from_file ~/work/arch/pkgs2.txt | yay --answerdiff None --answerclean None --mflags "--noconfirm " --needed -S -
yes | yay --answerdiff None --answerclean None --mflags "--noconfirm " --needed -S $(list_packages_from_file ~/work/arch/pkgs2.txt)

# is it weird that pacman doesnt handle this on its own when a new kernel is installed
sudo grub-mkconfig -o /boot/grub/grub.cfg

cd ~/work/sxiv/
sudo make install clean