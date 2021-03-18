# ZSH_Setup

Install and configure zsh environment. Single script which:
- installs brew (for MacOS only)
- installs many helpful packages (i.e. ``python3 rsync git``)
- sets default shell to ``zsh``
- installs [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) with plugins:
    - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
    - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
    - [zsh-completions](https://github.com/zsh-users/zsh-completions)
    - [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
    - [zsh-you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use)
    - ``git extract colorize cp rsync pip virtualenv command-not-found colored-man-pages catimg``
    - ``common-aliases`` (without ``rm/cp/mv -i``)
    - ``osx`` (for MacOS only)
- sets theme to [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- installs python pip packages (``virtualenv pygments``)
- adds some custom aliases (``edt src cls allow-apps``)
- installs [llvm](https://llvm.org/)
- installs [VSCodium](https://vscodium.com/)

# Requirements

Requires ``curl``:
- MacOS: ``brew update && brew install curl``
- Ubuntu: ``apt update && apt-get install -y curl``

# Install

## One liner

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/moozeq/ZSH_Setup/master/setup.sh)"
```

## Manual

```bash
git clone https://github.com/moozeq/ZSH_Setup.git
cd ZSH_Setup
./setup.sh
```

## Docker

```
docker build -t zsh-ubuntu github.com/moozeq/ZSH_Setup
docker run --name run_docker_run -it zsh-ubuntu
```