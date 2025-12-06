#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

## DNF5 Speedup
sed -i '/^\[main\]/a max_parallel_downloads=10' /etc/dnf/dnf.conf

## REPOS
# Repository that adds the chromium os kernel 
dnf5 -y copr enable sihawken/chromiumos-kernel
# RPMfusion repos
dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# Terra repo
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
# JamesDSPForLinux
dnf5 -y copr enable arrobbins/JDSP4Linux

## CINNAMON DESKTOP
dnf5 -y install @cinnamon-desktop
dnf5 -y remove firefox pidgin xawtv thunderbird hexchat xfburn shotwell transmission

## LIGHTDM & SLICK-GREETER
dnf5 -y install lightdm slick-greeter lightdm-settings
echo -e "[Seat:*]\ngreeter-session=slick-greeter" | tee /etc/lightdm/lightdm.conf.d/99-slick-greeter.conf

## PERFORMANCE OPTIMIZATION
dnf5 install -y zram-generator

# Zram optimization
tee /etc/systemd/zram-generator.conf > /dev/null <<EOF
[zram0]
zram-size = ram * 1.5
compression-algorithm = lz4
swap-priority = -1
EOF

## CHROMEBOOK KERNEL

KERNEL_VERSION=$(dnf list chromiumos-kernel -q | awk '/chromiumos-kernel/ {print $2}' | head -n 1 | cut -d'-' -f1)-chromiumos
dnf5 -y install --allowerasing chromiumos-kernel

# Ensure Initramfs is generated
depmod -a ${KERNEL_VERSION}
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "${KERNEL_VERSION}" --reproducible -v --add ostree -f "/lib/modules/${KERNEL_VERSION}/initramfs.img"
chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"

## CHROMEBOOK AUDIO (Install UCM configuration)
git clone --depth 1 https://github.com/WeirdTreeThing/alsa-ucm-conf-cros -b standalone /tmp/alsa-ucm-conf-cros
cp -a /tmp/alsa-ucm-conf-cros/ucm2 /usr/share/alsa/
cp -a /tmp/alsa-ucm-conf-cros/overrides /usr/share/alsa/ucm2/conf.d/

## FIRMWARE COMM
dnf5 -y install chromium-ectool --repo='https://repos.fyralabs.com/terra$releasever' 

## EXTRA PACKAGES
# Niceties
dnf5 install -y fastfetch git

## CLEAN UP
# Clean up dnf cache to reduce image size
dnf5 -y clean all