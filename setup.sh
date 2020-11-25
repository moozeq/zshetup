#!/usr/bin/env sh

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    apt update && apt install -y python3 python3-venv nano curl wget rsync git zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew update && brew install python3 curl wget rsync git zsh
else
    echo "[-] OS $OSTYPE not recognized, abort"
    exit 1
fi

chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

pip3 install virtualenv pygments

sed -i 's@ZSH_THEME="robbyrussell"@ZSH_THEME="powerlevel10k/powerlevel10k"@g' ~/.zshrc
sed -i 's@plugins=(git)@plugins=(git extract colorize cp rsync pip virtualenv zsh-autosuggestions zsh-syntax-highlighting)@g' ~/.zshrc

echo "alias edt='nano ~/.zshrc'" >> ~/.zshrc
echo "alias src='source ~/.zshrc'" >> ~/.zshrc
echo "alias cls='clear && printf \"\e[3J\"'" >> ~/.zshrc

zsh