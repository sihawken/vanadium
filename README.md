# Vanadium

A ublue-os inspired distribution with cosmic de, cachy-os kernel and packages, and additional akmod hardware support. 

## Features:

My system: Framework Laptop 13 (12th Gen Intel)

- Base Image: quay.io/fedora-ostree-desktops/cosmic-atomic:43
- kernel-cachyos-lto: https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-lto/
- cachy-os settings and ksm settings: https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/
- Ublue akmods (hardware support): https://copr.fedorainfracloud.org/coprs/ublue-os/akmods/
- Non-free multimedia packages
- A small list of default packages
- Flathub and cosmic flatpak repos replacing the default fedora flatpak repo
- Ublue-os non-free firmware: https://github.com/ublue-os/bazzite-firmware-nonfree
- Zsh default terminal with autosuggestion, syntax highlighting, and history substring terminal

## Why make this?

I wanted a distribution that:

- Runs the new Pop-OS Cosmic DE
- Has great hardware support and default configurations, similar to ublue-os distributions (Bazzite, Aurora, etc)
- Has Cachy-OS performance and resource management (bore scheduler, ksmd, zram paging)
- Default power-user zsh terminal configuration, similar to Ultramarine linux (https://ultramarine-linux.org/) 

## Installation instructions:

Install any atomic Fedora distribution (Silverblue, Kinoite, Bazzite, Aurora, ...)

Does not currently work with secureboot. That is on my list of improvements.

Run:

> [!WARNING]
> I built this image for me. Feel free to install, however any support requests may go unanswered for an extended period of time if I am unavailable. I will happily accept pull requests for any fixes or suggested improvements.

`rpm-ostree rebase ostree-image-signed:docker://ghcr.io/sihawken/vanadium`

