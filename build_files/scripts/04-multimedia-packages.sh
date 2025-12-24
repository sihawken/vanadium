#!/bin/bash

set -ouex pipefail

# Enable or Install Repofile
if ! grep -q fedora-multimedia <(dnf5 repolist); then
    dnf5 config-manager setopt fedora-multimedia.enabled=1 || \
    dnf5 config-manager addrepo --from-repofile="https://negativo17.org/repos/fedora-multimedia.repo"
fi

# Set higher priority (lower number = higher priority)
dnf5 config-manager setopt fedora-multimedia.priority=90

OVERRIDES=(
    "intel-gmmlib"
    "intel-mediasdk"
    "intel-vpl-gpu-rt"
    "libheif"
    "libva"
    "libva-intel-media-driver"
    "mesa-dri-drivers"
    "mesa-filesystem"
    "mesa-libEGL"
    "mesa-libGL"
    "mesa-libgbm"
    "mesa-va-drivers"
    "mesa-vulkan-drivers"
)

dnf5 -y install gstreamer1-plugins-bad-free-extras gstreamer1-plugin-openh264

# Sync packages to the versions in the multimedia repo
dnf5 distro-sync --skip-unavailable -y --repo='fedora-multimedia' "${OVERRIDES[@]}"

# Lock these packages so they aren't replaced by standard Fedora updates
dnf5 versionlock add "${OVERRIDES[@]}"