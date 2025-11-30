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
# RPMfusion repos
dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

## MULTIMEDIA PACKAGES
dnf5 swap -y ffmpeg-free ffmpeg --allowerasing
# dnf5 update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

## DESKTOP ENVIRONMENT
# Install XFCE Desktop Environment
dnf5 install -y \
    NetworkManager-fortisslvpn-gnome \
    NetworkManager-iodine-gnome \
    NetworkManager-l2tp-gnome \
    NetworkManager-libreswan-gnome \
    NetworkManager-openconnect-gnome \
    NetworkManager-openvpn-gnome \
    NetworkManager-pptp-gnome \
    NetworkManager-ssh-gnome \
    NetworkManager-sstp-gnome \
    NetworkManager-strongswan-gnome \
    NetworkManager-vpnc-gnome \
    Thunar \
    abrt-desktop \
    adwaita-gtk2-theme \
    adwaita-icon-theme \
    alsa-utils \
    blueman \
    desktop-backgrounds-compat \
    dnfdragora-updater \
    firewall-config \
    gnome-keyring-pam \
    greybird-dark-theme \
    greybird-light-theme \
    greybird-xfce4-notifyd-theme \
    greybird-xfwm4-theme \
    gtk-xfce-engine \
    gvfs \
    gvfs-archive \
    gvfs-mtp \
    initial-setup-gui \
    lightdm-gtk \
    mint-y-theme \
    network-manager-applet \
    nm-connection-editor \
    openssh-askpass \
    thunar-archive-plugin \
    thunar-media-tags-plugin \
    thunar-volman \
    tumbler \
    vim-enhanced \
    xdg-user-dirs-gtk \
    xfce4-about \
    xfce4-appfinder \
    xfce4-datetime-plugin \
    xfce4-panel \
    xfce4-panel-profiles \
    xfce4-places-plugin \
    xfce4-power-manager \
    xfce4-pulseaudio-plugin \
    xfce4-screensaver \
    xfce4-screenshooter-plugin \
    xfce4-session \
    xfce4-settings \
    xfce4-taskmanager \
    xfce4-terminal \
    xfconf \
    xfdesktop \
    xfwm4 \
    xfwm4-themes
# Install lightdm
dnf5 install -y lightdm lightdm-gtk
# Install XFCE utilities
dnf5 install -y blueman

## FONTS
dnf5 install -y google-noto-sans-fonts google-noto-color-emoji-fonts

## PACKAGE MANAGEMENT
dnf5 install -y gnome-software

## CHROMEBOOK PACKAGES
# Install Chromebook-specific keyboard configuration for hardware compatibility
# Note: This package handles function keys, trackpad, and media buttons.
dnf5 swap -y --allowerasing xkeyboard-config https://github.com/sihawken/xkeyboard-config-galliumos-rpm/releases/download/5eb120c/xkeyboard-config-galliumos-1.0.0-1.fc42.x86_64.rpm

# Install chromebook linux audio
dnf5 install -y chromebook-linux-audio

# 3. Install power and performance optimization tools
dnf5 install -y tlp tlp-rdw zram-generator

# Niceties
dnf5 install -y fastfetch

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