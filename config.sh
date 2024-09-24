#!/usr/bin/env sh

# run with sudo

source ./env.sh

# faster touchpad, tap to click, other touchpad features
cat << EOF > /etc/X11/xorg.conf.d/70-synaptics.conf
Section "InputClass"
Identifier "touchpad"
Driver "libinput"
MatchIsTouchpad "on"
Option "Tapping" "on"
Option "TapButton1" "1"
Option "TapButton2" "2"
Option "TapButton3" "2"
Option "VertEdgeScroll" "on"
Option "VertTwoFingerScroll" "on"
Option "HorizEdgeScroll" "on"
Option "HorizTwoFingerScroll" "on"
Option "AccelSpeed" "0.9"
EndSection
EOF

cat << EOF > /etc/systemd/system/my_mpv_logger_service.service
[Unit]
Description=mpv logger

[Service]
Restart=always
RuntimeMaxSec=3600
User=mahmooz
ExecStart=/bin/sh /home/mahmooz/work/scripts/mpv_logger.sh

[Install]
WantedBy=multi-user.target
EOF

# sudo without password
cat << 'EOF' > /etc/sudoers
mahmooz ALL=(ALL:ALL) NOPASSWD: ALL
EOF

cat << EOF > /usr/share/applications/mympv.desktop
[Desktop Entry]
Type=Application
Name=mympv
Exec=mympv.sh %F
Terminal=false
Icon=mpv
TryExec=mpv
Categories=AudioVideo;Audio;Video;Player;TV;
GenericName=mympv
EOF

# dont hibernate on lid close
sed -i "s/.*HandleLidSwitch=.*/HandleLidSwitch=ignore/" /etc/systemd/logind.conf
sed -i "s/.*HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/" /etc/systemd/logind.conf

# don handle power key
sed -i "s/.*HandlePowerKey=.*/HandlePowerKey=ignore/" /etc/systemd/logind.conf

# pacman config
sed -i "s/.*ParallelDownloads=.*/ParallelDownloads=5/" /etc/pacman.conf

# use multiple cores for compilation
sed -i "s/.*MAKEFLAGS=.*/MAKEFLAGS=\"-j12\"/" /etc/makepkg.conf

# udev

# ACTION=="add", SUBSYSTEM=="block", SUBSYSTEMS=="usb", ENV{ID_FS_UUID}=="777ddbd7-9692-45fb-977e-0d6678a4a213", RUN+="/usr/bin/mkdir -p /home/mahmooz/mnt" RUN+="/usr/bin/systemd-mount $env{DEVNAME} /home/mahmooz/mnt/", RUN+="/usr/bin/logger --tag my-manual-usb-mount udev rule for drive %k with uuid $env{ID_FS_UUID}"
# SUBSYSTEM=="block", ENV{ID_FS_UUID}=="be5af23f-da6d-42ee-a346-5ad3af1a299a", RUN+="mkdir -p /home/mahmooz/mnt2" RUN+="systemd-mount $env{DEVNAME} /home/mahmooz/mnt2", RUN+="logger --tag my-manual-usb-mount udev rule for drive %k with uuid $env{ID_FS_UUID}"
cat << 'EOF' > /etc/udev/rules.d/mystorage.rules
SUBSYSTEM=="block", ENV{ID_FS_UUID}=="777ddbd7-9692-45fb-977e-0d6678a4a213", RUN+="/bin/sh -c '/usr/bin/mkdir -p /home/mahmooz/mnt; /usr/bin/systemd-mount %E{DEVNAME} /home/mahmooz/mnt; /usr/bin/logger --tag my-manual-usb-mount udev rule for drive %k with uuid %E{ID_FS_UUID}'"
SUBSYSTEM=="block", ENV{ID_FS_UUID}=="be5af23f-da6d-42ee-a346-5ad3af1a299a", RUN+="/bin/sh -c '/usr/bin/mkdir -p /home/mahmooz/mnt2; /usr/bin/systemd-mount %E{DEVNAME} /home/mahmooz/mnt2; /usr/bin/logger --tag my-manual-usb-mount udev rule for drive %k with uuid %E{ID_FS_UUID}'"
EOF

su "$MAIN_USER" mkdir -p "$WORK_DIR" 2>/dev/null
# su --preserve-environment "$MAIN_USER" << 'EOF'
# echo "$WORK_DIR"
# echo "$MAIN_USER"
# for repo in otherdots nvim scripts arch awesome nixos emacs.d; do
#     if [ ! -d "$WORK_DIR/$repo" ]; then
#         remote="https://github.com/mahmoodsheikh36/$repo"
#         echo cloning $remote
#         cd "$WORK_DIR"
#         git clone $remote
#     fi
#     echo restoring $repo
#     cd "$WORK_DIR/$repo"
#     ./restore.sh
# done
# EOF

for service in NetworkManager sshd mongodb my_mpv_logger_service dictd bluetooth gdm; do
    systemctl enable $service
    systemctl is-active --quiet $service || systemctl start $service
done
