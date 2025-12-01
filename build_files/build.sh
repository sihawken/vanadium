#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

## REPOS
# Repository to enable audio support on chromebook devices
dnf5 -y copr enable pvermeer/chromebook-linux-audio fedora-$(rpm -E %fedora)-x86_64
# Repository that adds the gallium os xkeyboard-config 
dnf5 -y copr enable sihawken/xkeyboard-config-galliumos-rpm
# Repository for TLPUI
dnf5 -y copr enable sunwire/tlpui fedora-$(rpm -E %fedora)-x86_64
# # RPMfusion repos
dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

## CHROMEBOOK PACKAGES
# Enables keyboard layouts for chromebooks
# dnf5 -y swap xkeyboard-config xkeyboard-config-galliumos-rpm --allowerasing
# # Fixes audio issues for chromebooks
# dnf5 install -y chromebook-linux-audio

## CINNAMON DESKTOP
dnf5 -y install @cinnamon-desktop
dnf5 -y remove firefox pidgin xawtv thunderbird

## LIGHTDM & SLICK-GREETER
dnf -y install lightdm slick-greeter lightdm-settings
echo -e "[Seat:*]\ngreeter-session=slick-greeter" | tee /etc/lightdm/lightdm.conf.d/99-slick-greeter.conf

# ## MULTIMEDIA PACKAGES
dnf5 -y swap ffmpeg-free ffmpeg --allowerasing
dnf5 -y install intel-media-driver libva-intel-driver
# dnf5 -y swap mesa-va-drivers mesa-va-drivers-freeworld --allowerasing
# dnf5 -y install mesa-vdpau-drivers-freeworld

# 3. Install power and performance optimization tools
# dnf5 install -y tlp tlp-rdw tlpui zram-generator

# ## OPTIMIZATION
# # Zram optimization
# tee /etc/systemd/zram-generator.conf > /dev/null <<EOF
# [zram0]
# zram-size = ram * 1.5
# compression-algorithm = lz4
# swap-priority = -1
# EOF

# Create a file to limit streams to 2
# mkdir -p /etc/systemd/system/systemd-zram-setup@zram0.service.d/
# tee /etc/systemd/system/systemd-zram-setup@zram0.service.d/override.conf > /dev/null <<EOF
# [Service]
# # Set max compression streams to 2 (GalliumOS default)
# ExecStartPost=/bin/bash -c 'echo 2 > /sys/block/zram0/max_comp_streams'
# EOF

# Niceties
dnf5 install -y fastfetch

# systemctl enable tlp.service

# Clean up dnf cache to reduce image size
dnf5 -y clean all