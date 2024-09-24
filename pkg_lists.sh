#!/usr/bin/env sh
# this file needs to be sourced because it sets some envvars

# list packages written in a var, ignore text after '#', the packages must
# have no spaces in their names
parse_package_list() {
    echo "$1" | sed 's/#.*$//g' | tr '\n' ' '
}
# for x in $(echo $hi); do echo got $x; done

export BASE_PACKAGE_LIST=$(parse_package_list '
zsh
git
# emacs
neovim
xfce4
awesome
kitty
mpv
sxhkd
awesome
touchegg
hsetroot
feh
texlive
ripgrep
neovide
zathura
foliate
rofi
pkgfile
xdg-utils
pulseaudio
pulsemixer
openssh
mosh
xclip
firefox
yt-dlp
gdb
tree
rsync
sshfs
ffmpeg
imagemagick
transmission-cli
socat
zathura-pdf-mupdf
zathura-djvu
maim
# parcellite
dictd
bluez
bluez-utils
jq
ttf-monaspace-variable
gdisk
tree-sitter-cli
okular
zip
unzip
sagemath
pandoc
gzip
iftop
btop
android-tools
vim
# python-beautifulsoup4
vscode-json-languageserver
libreoffice
wezterm
notmuch
isync
pulseaudio-bluetooth
lshw
inkscape
iotop
liquidctl
openrgb
jupyter-notebook
ninja
dosfstools
jdk-openjdk

ollama

# for emacs compilation
webkit2gtk libgccjit

arch-install-scripts
linux-lts
base
base-devel
networkmanager
grub
efibootmgr
linux-firmware sof-firmware
xorg
xorg-xinit

gdm
hyprland

nodejs
npm
sbcl
python-magic
coq

lua-language-server
python-lsp-server
pyright
typescript-language-server
bash-language-server

noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
ttf-inconsolata
')

export AUR_PACKAGE_LIST=$(parse_package_list '
brave-bin
# spotdl
# mongodb-bin
# youtube-music-bin
firebase-tools-bin
# tor-browser
# mongodb-tools-bin
woeusb-ng
light
julia-bin
python-huggingface-hub
adb-sync-git
downgrade
# koboldcpp-bin
# miniconda3
xremap-wlroots-bin

dict-gcide dict-wn dict-moby-thesaurus
')

export NVIDIA_PACKAGE_LIST=$(parse_package_list '
nvidia-lts nvidia-settings nvidia-utils
nvtop
cuda cuda-tools
')
