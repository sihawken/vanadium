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

## NICE-TO-HAVE-PACKAGES
dnf5 install -y tmux 

## MULTIMEDIA PACKAGES
dnf5 swap -y ffmpeg-free ffmpeg --allowerasing
dnf5 update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

## DESKTOP ENVIRONMENT
# Install XFCE Desktop Environment and a lightweight Display Manager
dnf5 install -y @xfce-desktop lightdm-gtk

## CHROMEBOOK PACKAGES
# Install Chromebook-specific keyboard configuration for hardware compatibility
# Note: This package handles function keys, trackpad, and media buttons.
dnf5 remove -y --noautoremove xkeyboard-config # Conflicts with the gallium os xkeyboard config
dnf5 install -y https://github.com/sihawken/xkeyboard-config-galliumos-rpm/releases/download/5eb120c/xkeyboard-config-galliumos-1.0.0-1.fc42.x86_64.rpm

# Install chromebook linux audio
dnf5 install -y chromebook-linux-audio

# 3. Install power and performance optimization tools
dnf5 install -y tlp tlp-rdw zram-generator

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

## ENABLE SERVICES

systemctl enable tlp.service
systemctl enable podman.socket
