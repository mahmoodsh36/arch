#!/usr/bin/env sh
# this file needs to be sourced
export main_server_ipv6 = "2a01:4f9:c012:ad1b::1";
export main_server_user = "root";
export main_server_ip = "95.217.0.99";
export home_server_ip = "192.168.1.150";
export main_user = "mahmooz";
export home_dir = "/home/mahmooz";
export work_dir = "/home/${main_user}/work";
export scripts_dir = "${work_dir}/scripts";
export dotfiles_dir = "${work_dir}/otherdots";
export blog_dir = "${work_dir}/blog";
export brain_dir = "${home_dir}/brain";
export music_dir = "${home_dir}/music";
export notes_dir = "${brain_dir}/notes";
export data_dir = "${home_dir}/data";
export mpv_socket_dir = "${data_dir}/mpv_data/sockets";
export mpv_main_socket_path = "${data_dir}/mpv_data/sockets/mpv.socket";
export personal_website = "https://mahmoodsh36.github.io";
export EDITOR = "nvim";
export BROWSER = "brave";