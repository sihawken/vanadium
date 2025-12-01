#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

## REPOS
# Repository that adds the gallium os xkeyboard-config 
dnf5 -y copr enable sihawken/xkeyboard-config-galliumos-rpm
# Repository for TLPUI
dnf5 -y copr enable sunwire/tlpui fedora-$(rpm -E %fedora)-x86_64
# # RPMfusion repos
dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

## CHROMEBOOK PACKAGES
# Enables keyboard layouts for chromebooks
# dnf5 -y swap xkeyboard-config xkeyboard-config-galliumos-rpm

## CHROMEBOOK AUDIO (Install UCM configuration)
git clone --depth 1 https://github.com/WeirdTreeThing/alsa-ucm-conf-cros -b standalone /tmp/alsa-ucm-conf-cros
cp -a /tmp/alsa-ucm-conf-cros/ucm2 /usr/share/alsa/
cp -a /tmp/alsa-ucm-conf-cros/overrides /usr/share/alsa/ucm2/conf.d/

# rpm-ostree override remove xkeyboard-config --install xkeyboard-config-galliumos-rpm

## CINNAMON DESKTOP
dnf5 -y install @cinnamon-desktop
dnf5 -y remove firefox pidgin xawtv thunderbird hexchat xfburn shotwell transmission

## LIGHTDM & SLICK-GREETER
dnf -y install lightdm slick-greeter lightdm-settings
echo -e "[Seat:*]\ngreeter-session=slick-greeter" | tee /etc/lightdm/lightdm.conf.d/99-slick-greeter.conf

# ## MULTIMEDIA PACKAGES
dnf5 -y swap ffmpeg-free ffmpeg --allowerasing
dnf5 -y install intel-media-driver libva-intel-driver
dnf5 -y swap mesa-va-drivers mesa-va-drivers-freeworld --allowerasing
dnf5 -y install mesa-vdpau-drivers-freeworld

# Install power and performance optimization tools
dnf5 install -y zram-generator

## OPTIMIZATION
# Zram optimization
tee /etc/systemd/zram-generator.conf > /dev/null <<EOF
[zram0]
zram-size = ram * 1.5
compression-algorithm = lz4
swap-priority = -1
EOF

# Niceties
dnf5 install -y fastfetch git

# Clean up dnf cache to reduce image size
dnf5 -y clean all