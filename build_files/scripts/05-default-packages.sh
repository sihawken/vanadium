#!/bin/bash

set -ouex pipefail

dnf5 -y remove firefox firefox-langpacks toolbox

# Category: Hardware & Peripheral Management
dnf5 -y install libratbag-ratbagd solaar-udev openrgb-udev-rules nvme-cli smartmontools lshw powerstat intel-vaapi-driver oversteer-udev alsa-firmware android-udev-rules

# Category: Containers & Sandboxing
dnf5 -y install distrobox flatpak-spawn

# Category: Terminal Utilities & Productivity
dnf5 -y install fastfetch ptyxis nano htop tmux fzf just wl-clipboard

# Category: Networking & Connectivity
dnf5 -y install net-tools tcpdump traceroute wireguard-tools

# Category: Security & Authentication
dnf5 -y install yubikey-manager pam-u2f pam_yubico pamu2fcfg

# Category: Mobile Device Support
dnf5 -y install libimobiledevice-utils usbmuxd

# Category: Typography & Internationalization
dnf5 -y install google-noto-sans-balinese-fonts google-noto-sans-cjk-fonts google-noto-sans-javanese-fonts google-noto-sans-sundanese-fonts

# Category: Graphics, Media & Thumbnails
dnf5 -y install heif-pixbuf-loader libheif ffmpegthumbnailer fdk-aac libfdk-aac ffmpeg ffmpeg-libs libavcodec mesa-libxatracker

# Category: Multimedia Infrastructure & Cameras
dnf5 -y install libcamera libcamera-gstreamer libcamera-ipa libcamera-tools pipewire-libs-extra pipewire-plugin-libcamera

# Category: Filesystem & Archive Tools
dnf5 -y install zstd fuse squashfs-tools symlinks

# Category: System Libraries & Low-Level Tools
dnf5 -y install nvtop apr apr-util openssl grub2-tools-extra

