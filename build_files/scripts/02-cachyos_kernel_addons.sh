#!/bin/bash

set -ouex pipefail

#### CACHY OS KERNEL

# Install CachyOS kernel addons
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
# Required to install CachyOS settings
rm -rf /usr/lib/systemd/coredump.conf
# Install KSMD and CachyOS-Settings
dnf5 -y install  --allowerasing

dnf5 versionlock add cachyos-settings cachyos-ksm-settings
dnf5 -y copr disable bieszczaders/kernel-cachyos-addons

# Enable KSMD
tee "/usr/lib/systemd/system/ksmd.service" > /dev/null <<EOF
[Unit]
Description=Activates Kernel Samepage Merging
ConditionPathExists=/sys/kernel/mm/ksm

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/ksmctl -e
ExecStop=/usr/bin/ksmctl -d

[Install]
WantedBy=multi-user.target
EOF

ln -s /usr/lib/systemd/system/ksmd.service /etc/systemd/system/multi-user.target.wants/ksmd.service
