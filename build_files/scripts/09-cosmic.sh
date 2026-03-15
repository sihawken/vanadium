#!/bin/bash

# Update to newest release of cosmic
dnf5 -y copr enable adil192/cosmic-epoch
dnf5 -y update

# Remove cosmic-player
dnf5 -y remove cosmic-player