#!/bin/bash

set -ouex pipefail

# Configuration
REPO_URL="https://github.com/ublue-os/bazzite-firmware-nonfree.git"
TEMP_DIR=$(mktemp -d)
TARGET_DIR="/usr/lib/firmware"

git clone --depth 1 "$REPO_URL" "$TEMP_DIR"

if [ $? -eq 0 ]; then
    echo "Copying firmware files to $TARGET_DIR..."
    # Copy contents from the usr/lib/firmware directory in the repo to system /usr/lib/firmware
    cp -rv "$TEMP_DIR/usr/lib/firmware/"* "$TARGET_DIR/"

    echo "Decompressing .xz firmware files..."
    # Some kernels require uncompressed files; others handle .xz. This ensures compatibility.
    find "$TARGET_DIR" -name "*.xz" -exec sudo xz -d {} +

    echo "Setting permissions..."
    chown -R root:root "$TARGET_DIR"
    chmod -R 644 "$TARGET_DIR"
    # Directories need +x to be traversable
    find "$TARGET_DIR" -type d -exec sudo chmod 755 {} +

    echo "Cleaning up..."
    rm -rf "$TEMP_DIR"

    echo "Installation complete. It is recommended to reboot your system."
else
    echo "Failed to clone repository. Please check your internet connection and git installation."
    exit 1
fi