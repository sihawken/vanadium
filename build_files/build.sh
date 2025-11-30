#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

## REPOS
# Repository to enable audio support on chromebook devices
dnf5 -y copr enable pvermeer/chromebook-linux-audio
# Repository for TLPUI
dnf5 -y copr enable sunwire/tlpui
# RPMfusion repos
dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

## MULTIMEDIA PACKAGES
dnf5 swap -y ffmpeg-free ffmpeg --allowerasing
# dnf5 update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

## FONTS
dnf5 install -y google-noto-sans-fonts google-noto-color-emoji-fonts

## PACKAGE MANAGEMENT
dnf5 install -y gnome-software

## CHROMEBOOK PACKAGES
# Install Chromebook-specific keyboard configuration for hardware compatibility
# Note: This package handles function keys, trackpad, and media buttons.
dnf5 swap -y xkeyboard-config https://github.com/sihawken/xkeyboard-config-galliumos-rpm/releases/download/0272a55/xkeyboard-config-galliumos-1.0.0-1.fc42.x86_64.rpm

# Install chromebook linux audio
dnf5 install -y chromebook-linux-audio

# 3. Install power and performance optimization tools
dnf5 install -y tlp tlp-rdw tlpui zram-generator

## OPTIMIZATION
# Zram optimization
tee /etc/systemd/zram-generator.conf > /dev/null <<EOF
[zram0]
zram-size = ram * 1.5
compression-algorithm = lz4
swap-priority = -1
EOF

# Create a file to limit streams to 2
sudo tee /etc/systemd/system/systemd-zram-setup@zram0.service.d/override.conf > /dev/null <<EOF
[Service]
# Set max compression streams to 2 (GalliumOS default)
ExecStartPost=/bin/bash -c 'echo 2 > /sys/block/zram0/max_comp_streams'
EOF

## UBLUE OS STUFF
if [[ "$(rpm -E %fedora)" -gt 41 ]]; then
  dnf5 -y copr enable ublue-os/staging
  dnf5 -y swap --repo='copr:copr.fedorainfracloud.org:ublue-os:staging' \
    rpm-ostree rpm-ostree
  dnf5 versionlock add rpm-ostree
  dnf5 -y copr disable ublue-os/staging
fi

dnf5 install -y ublue-os-udev-rules ublue-os-update-services ublue-os-signing ublue-os-luks ublue-os-just

# Niceties
dnf5 install -y fastfetch

# Clean up dnf cache to reduce image size
dnf5 clean -y all

systemctl enable systemd-zram-setup@zram0.service
systemctl enable tlp.service
systemctl enable podman.socket
# Autoupdate
systemctl enable rpm-ostreed-automatic.timer