#!/usr/bin/env sh

apt update && apt install -y python3 python3-dev python3-pip python3-venv nano curl wget rsync git zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended