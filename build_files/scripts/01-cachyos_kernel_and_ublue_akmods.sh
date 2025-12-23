#!/bin/bash

set -ouex pipefail

#### KERNEL MODIFICATION INIT

# create a shims to bypass kernel install triggering dracut/rpm-ostree
# seems to be minimal impact, but allows progress on build
cd /usr/lib/kernel/install.d \
&& mv 05-rpmostree.install 05-rpmostree.install.bak \
&& mv 50-dracut.install 50-dracut.install.bak \
&& printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install \
&& printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install \
&& chmod +x  05-rpmostree.install 50-dracut.install

#### CACHY OS KERNEL

# Install CachyOS kernel
dnf5 -y copr enable bieszczaders/kernel-cachyos
dnf5 -y remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra 
rm -rf /lib/modules/* # Remove kernel files that remain

dnf5 -y install kernel-cachyos kernel-cachyos-devel-matched --allowerasing
dnf5 versionlock add kernel-cachyos kernel-cachyos-devel-matched
dnf5 -y copr disable bieszczaders/kernel-cachyos

#### UBLUE-OS AKMODS

RELEASE=$(/usr/bin/rpm -E %fedora)
ARCH=$(/usr/bin/rpm -E '%_arch')
KERNEL=$(dnf5 list kernel-cachyos -q | awk '/kernel-cachyos/ {print $2}' | head -n 1 | cut -d'-' -f1)-cachyos1.fc${RELEASE}.${ARCH}

dnf5 -y copr enable ublue-os/akmods

# Framework laptop
dnf install -y akmod-framework-laptop-*.fc"${RELEASE}"."${ARCH}" | \
akmods --force --kernels "${KERNEL}" --kmod framework-laptop

#### KERNEL MODIFICATION FINAL

# Regen initramfs
depmod -a ${KERNEL}
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "${KERNEL}" --reproducible -v --add ostree -f "/lib/modules/${KERNEL}/initramfs.img"
chmod 0600 "/lib/modules/${KERNEL}/initramfs.img"

# restore kernel install
mv -f 05-rpmostree.install.bak 05-rpmostree.install \
&& mv -f 50-dracut.install.bak 50-dracut.install
cd -