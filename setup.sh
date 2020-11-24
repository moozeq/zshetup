#!/usr/bin/env sh

apt update && apt install -y python3 python3-dev python3-pip python3-venv nano curl wget rsync git zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

pip3 install virtualenv Pygments

sed -i 's@ZSH_THEME="robbyrussell"@ZSH_THEME="powerlevel10k/powerlevel10k"@g' ~/.zshrc
sed -i 's@plugins=(git)@plugins=(git extract colorize cp rsync pip virtualenv zsh-autosuggestions zsh-syntax-highlighting)@g' ~/.zshrc

echo "alias edt='nano ~/.zshrc'" >> ~/.zshrc
echo "alias edt='nano ~/.zshrc'" >> ~/.zshrc
echo "alias cls='clear && printf \"\e[3J\"'" >> ~/.zshrc

zsh