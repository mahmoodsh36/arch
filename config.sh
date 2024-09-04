#!/usr/bin/env sh

# run with sudo

cat <<EOF > /etc/X11/xorg.conf.d/70-synaptics.conf
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

cat <<EOF > /etc/systemd/system/my_mpv_logger_service.service
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

cat <<EOF > /etc/sudoers
mahmooz ALL=(ALL:ALL) NOPASSWD: ALL
EOF

cat <<EOF > /usr/share/applications/mympv.desktop
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

for service in NetworkManager sshd mongodb my_mpv_logger_service; do
    systemctl enable $service
    systemctl is-active --quiet $service || systemctl start $service
done