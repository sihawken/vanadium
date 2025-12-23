#!/bin/bash

set -ouex pipefail

# Remove Fedora Flatpak and related packages
dnf5 remove -y \
    fedora-flathub-remote

# Add Flathub to the image for eventual application
mkdir -p /etc/flatpak/remotes.d/

# Add flathub repo
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

# Add cosmic repo
curl --retry 3 -Lo /etc/flatpak/remotes.d/cosmic.flatpakrepo https://apt.pop-os.org/cosmic/cosmic.flatpakrepo

# Fedora Flatpak service is a part of the flatpak package, ensure it's overridden by moving to replace it at the end of the build.
mv -f /usr/lib/systemd/system/flatpak-add-flathub-repos.service /usr/lib/systemd/system/flatpak-add-fedora-repos.service


