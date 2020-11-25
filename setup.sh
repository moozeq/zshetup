#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    apt update && apt install -y python3 python3-dev python3-pip python3-venv nano curl wget rsync git zsh sudo
elif [[ "$OSTYPE" == "darwin"* ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew update && brew install python3 curl wget rsync git zsh
else
    echo "[-] OS $OSTYPE not recognized, abort"
    exit 1
fi

# check if successfully installed zsh
# if not, install from sources
if [[ ! $(which zsh) ]]; then
    curl -L https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz > ncurses.tar.gz
    tar xf ncurses.tar.gz
    cd ncurses-*
    ./configure --prefix=$HOME/local CXXFLAGS="-fPIC" CFLAGS="-fPIC"
    make -j && make install
    cd ..

    curl -L https://sourceforge.net/projects/zsh/files/latest/download > zsh.tar.xz
    tar xf zsh.tar.xz
    cd zsh-*
    ./configure --prefix="$HOME/local" CPPFLAGS="-I$HOME/local/include" LDFLAGS="-L$HOME/local/lib"
    make -j && make install
    cd ..

    # export path to zsh
    export PATH=$HOME/local/bin:$PATH

    # change default shell
    echo "export PATH=\$HOME/local/bin:\$PATH" >> ~/.bashrc
    echo "export SHELL=\`which zsh\`" >> ~/.bashrc
    echo "[ -f \"\$SHELL\" ] && exec \"\$SHELL\" -l" >> ~/.bashrc
fi

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

pip3 install --user virtualenv pygments

sed -i 's@ZSH_THEME="robbyrussell"@ZSH_THEME="powerlevel10k/powerlevel10k"@g' ~/.zshrc
sed -i 's@plugins=(git)@plugins=(git extract colorize cp rsync pip virtualenv zsh-autosuggestions zsh-syntax-highlighting)@g' ~/.zshrc

echo "alias edt='nano ~/.zshrc'" >> ~/.zshrc
echo "alias src='source ~/.zshrc'" >> ~/.zshrc
echo "alias cls='clear && printf \"\e[3J\"'" >> ~/.zshrc
echo "alias ll='ls -hla'" >> ~/.zshrc
echo "export PATH=\"\$PATH:\$HOME/.local/bin\"" >> ~/.zshrc

zsh