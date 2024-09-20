#!/usr/bin/env sh

source ./env.sh
source ./per_machine.sh

# packages written in a file, ignore lines starting with #
list_packages_from_file() {
    grep -v '^#' "$1"
}

# begin installing packages
echo installing packages

# base packages
sudo pacman --needed --noconfirm -S $BASE_PACKAGE_LIST || exit 1

# nvidia packages
if $MY_ENABLE_NVIDIA; then
    echo installing nvidia packages
    sudo pacman --needed --noconfirm -S $BASE_PACKAGE_LIST || exit 1
fi

# aur packages
setup_yay() {
    yay --version && return 1
    mkdir -p ~/.cache/yay/ 2>/dev/null
    cd ~/.cache/yay/
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    # cd ..
    # rm -rf yay
}
# install aur packages
setup_yay
# yay apparently doesnt auto resolve conflicts even with --noconfirm, so we use 'yes'
# list_packages_from_file ~/work/arch/pkgs2.txt | yay --answerdiff None --answerclean None --mflags "--noconfirm " --needed -S -
yes | yay --answerdiff None --answerclean None --mflags "--noconfirm " --needed -S $AUR_PACKAGE_LIST || exit 1

# is it weird that pacman doesnt handle this on its own when a new kernel is installed
sudo grub-mkconfig -o /boot/grub/grub.cfg || exit 1

cd ~/work/sxiv/
sudo make install clean


echo done!
