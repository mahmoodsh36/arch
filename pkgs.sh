#!/usr/bin/env sh
sudo pacman --needed --noconfirm -S - < ~/work/arch/pkgs.txt

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

setup_yay
yay --needed --noconfirm -S - < ~/work/arch/pkgs2.txt

cd ~/work/sxiv/
sudo make install clean
