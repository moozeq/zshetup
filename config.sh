#!/usr/bin/env zsh

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

pip3 install virtualenv Pygments

sed -i 's@ZSH_THEME="robbyrussell"@ZSH_THEME="powerlevel10k/powerlevel10k"@g' ~/.zshrc
sed -i 's@plugins=(git)@plugins=(git extract colorize cp rsync pip virtualenv zsh-autosuggestions zsh-syntax-highlighting)@g' ~/.zshrc

echo "alias edt='nano ~/.zshrc'" >> ~/.zshrc
echo "alias edt='nano ~/.zshrc'" >> ~/.zshrc
echo "alias cls='clear && printf \"\e[3J\"'" >> ~/.zshrc