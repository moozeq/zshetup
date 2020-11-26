#!/usr/bin/env bash

install_packages() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # install sudo if not found
        if [[ ! $(which sudo) ]]; then
            apt-get update && apt-get install -y sudo
        fi
        echo "[*] Installing packages, if you are not in sudoers, skip this step with CTRL + C"
        sudo apt-get update && sudo apt-get install -y build-essential python3 python3-dev python3-pip python3-venv nano curl wget rsync git zsh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # install brew if not found
        if [[ ! $(which brew) ]]; then
            bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        fi
        brew update
        brew install python3 curl wget rsync git imagemagick gcc zsh llvm
        brew install --cask visual-studio-code
    else
        echo "[-] OS $OSTYPE not recognized, abort"
        exit 1
    fi
}

install_zsh_from_sources() {
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

    # cleanup
    rm ncurses.tar.gz
    rm -rf ncurses-*
    rm zsh.tar.xz
    rm -rf zsh-*
}

install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

install_pip_modules() {
    pip3 install --user virtualenv pygments
}

install_plugins() {
    # download external plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
    git clone https://github.com/MichaelAquilina/zsh-you-should-use ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use

    # add plugins
    CUSTOM_PLUGINS="you-should-use git extract colorize cp rsync pip virtualenv command-not-found colored-man-pages catimg zsh-autosuggestions zsh-syntax-highlighting zsh-completions history-substring-search"
    if [[ "$OSTYPE" == "darwin"* ]]; then CUSTOM_PLUGINS="$CUSTOM_PLUGINS osx"; fi # add osx plugin if MacOS
    sed -i "s@plugins=(git)@plugins=($CUSTOM_PLUGINS)@g" ~/.zshrc

    # change autosuggest background
    echo "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'" >> ~/.zshrc
    echo "export TERM=xterm-256color" >> ~/.zshrc
}

install_powerlevel10k() {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i 's@ZSH_THEME="robbyrussell"@ZSH_THEME="powerlevel10k/powerlevel10k"@g' ~/.zshrc
}

install_custom_aliases() {
    # get common-aliases but comment rm/cp/mv -i
    CUSTOM_ALIASES=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/custom-aliases.zsh
    cp ${ZSH:-$HOME/.oh-my-zsh}/plugins/common-aliases/common-aliases.plugin.zsh $CUSTOM_ALIASES
    sed -i "s@alias rm='rm -i'@# alias rm='rm -i'@g" $CUSTOM_ALIASES
    sed -i "s@alias cp='cp -i'@# alias cp='cp -i'@g" $CUSTOM_ALIASES
    sed -i "s@alias mv='mv -i'@# alias mv='mv -i'@g" $CUSTOM_ALIASES
    # add custom aliases edt, src and cls
    echo "alias edt='nano ~/.zshrc'" >> $CUSTOM_ALIASES
    echo "alias src='source ~/.zshrc'" >> $CUSTOM_ALIASES
    echo "alias cls='clear && printf \"\e[3J\"'" >> $CUSTOM_ALIASES
    # add allow-apps hidden option if MacOS
    if [[ "$OSTYPE" == "darwin"* ]]; then echo "alias allow-apps='sudo spctl --master-disable'" >> $CUSTOM_ALIASES; fi
}

install_vscode_linux() {
    # do it only after zsh setup
    curl -L https://go.microsoft.com/fwlink/?LinkID=620884 > $HOME/code.tar.gz
    tar xf $HOME/code.tar.gz --directory $HOME
    rm $HOME/code.tar.gz
    echo "export PATH=\"\$PATH:\$HOME/VSCode-linux-x64/bin\"" >> ~/.zshrc
}

install_llvm_linux() {
    bash -c "$(curl -fsSL https://apt.llvm.org/llvm.sh)"
}

change_default_shell() {
    chsh -s $(which zsh)
}

##################################################################
####################### SCRIPT STARTS HERE #######################
##################################################################

install_packages

# check if successfully installed zsh
# if not, install from sources
if [[ ! $(which zsh) ]]; then
    echo "[*] zsh not found, try install from sources"
    install_zsh_from_sources
fi

# still no zsh? abort
if [[ ! $(which zsh) ]]; then
    echo "[-] Could not install zsh from sources, sorry, abort"
    exit 1
fi

install_oh_my_zsh
install_plugins
install_powerlevel10k
install_pip_modules
install_custom_aliases

if [[ ! $(which code) && "$OSTYPE" == "linux-gnu"* ]]; then
    echo "[*] Visual Studio Code not found, installing"
    install_vscode_linux
fi

if [[ ! $(which clang) && "$OSTYPE" == "linux-gnu"* ]]; then
    echo "[*] clang not found, installing"
    install_llvm_linux
fi

# add .local bin directory
echo "export PATH=\"\$PATH:\$HOME/.local/bin:\$HOME/local/bin\"" >> ~/.zshrc

change_default_shell

echo "[+] Done, now reopen terminal/ssh"