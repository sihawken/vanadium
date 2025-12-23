#!/bin/bash

set -ouex pipefail

dnf5 -y install \
    libratbag-ratbagd solaar-udev openrgb-udev-rules \
    distrobox flatpak-spawn \
    heif-pixbuf-loader libheif ffmpegthumbnailer \
    fastfetch ptyxis \
    nano htop tmux fzf just zstd \
    net-tools tcpdump traceroute wireguard-tools \
    nvtop nvme-cli smartmontools lshw powerstat \
    fuse squashfs-tools symlinks wl-clipboard \
    apr apr-util openssl grub2-tools-extra

dnf5 -y remove firefox firefox-langpacks toolbox

