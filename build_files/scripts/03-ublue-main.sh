#!/bin/bash

set -ouex pipefail

dnf5 -y copr enable ublue-os/packages
dnf5 -y install ublue-os-udev-rules ublue-os-update-services ublue-os-signing ublue-os-luks ublue-os-just
dnf5 versionlock add ublue-os-udev-rules ublue-os-update-services ublue-os-signing ublue-os-luks ublue-os-just
dnf5 -y copr disable ublue-os/packages