#!/bin/bash

set -ouex pipefail

dnf5 -y install \
    zsh starship util-linux-user

# 1. Create the system-wide Zsh configuration
# This ensures every new user gets the Ultramarine style
mkdir -p /etc/skel/.zsh

# 2. Download Ultramarine/Standard Zsh plugins into the system skeleton
git clone https://github.com/zsh-users/zsh-autosuggestions /etc/skel/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/skel/.zsh/zsh-syntax-highlighting

# 3. Create the default .zshrc in /etc/skel
cat <<EOF > /etc/skel/.zshrc
# Ultramarine-style Zsh Config
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Starship Init
eval "\$(starship init zsh)"
EOF

# 4. Set the default Starship preset
mkdir -p /etc/skel/.config
starship preset nerd-font-symbols -o /etc/skel/.config/starship.toml

# 5. Set Zsh as the default shell for the image
# On uBlue/Atomic, we modify /etc/default/useradd or just set it via usermod for existing users
sed -i 's/SHELL=\/bin\/bash/SHELL=\/usr\/bin\/zsh/g' /etc/default/useradd

