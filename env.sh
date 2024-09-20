#!/usr/bin/env sh
# this file needs to be sourced
export MAIN_SERVER_IPV6="2a01:4f9:c012:ad1b::1";
export MAIN_SERVER_USER="root";
export MAIN_SERVER_IP="95.217.0.99";
export HOME_SERVER_IP="192.168.1.150";
export MAIN_USER="mahmooz";
export MY_HOME_DIR="/home/${MAIN_USER}";
export WORK_DIR="/home/${MAIN_USER}/work";
export SCRIPTS_DIR="${WORK_DIR}/scripts";
export DOTFILES_DIR="${WORK_DIR}/otherdots";
export BLOG_DIR="${WORK_DIR}/blog";
export BRAIN_DIR="${MY_HOME_DIR}/brain";
export MUSIC_DIR="${MY_HOME_DIR}/music";
export NOTES_DIR="${BRAIN_DIR}/notes";
export DATA_DIR="${MY_HOME_DIR}/data";
export MPV_SOCKET_DIR="${DATA_DIR}/mpv_data/sockets";
export MPV_MAIN_SOCKET_PATH="${DATA_DIR}/mpv_data/sockets/mpv.socket";
export PERSONAL_WEBSITE="https://mahmoodsh36.github.io";
export EDITOR="nvim";
export BROWSER="firefox";
export TERMINAL="wezterm";

source $WORK_DIR/arch/pkg_lists.sh
