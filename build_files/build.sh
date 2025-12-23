#!/bin/bash

set -ouex pipefail

for script in ./scripts/*.sh; do
    echo "Running $script..."
    /bin/bash "$script"
done