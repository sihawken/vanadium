#!/bin/bash

set -ouex pipefail

PARENT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)

for script in "$PARENT_PATH/scripts"/*.sh; do
    [ -e "$script" ] || continue
    
    echo "Executing: $(basename "$script")"
    bash "$script"
done