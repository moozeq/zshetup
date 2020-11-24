# ZSH_Setup

Install and configure zsh environment. Single script which:
- installs packages (``python3 python3-dev python3-pip python3-venv nano curl wget rsync git zsh``)
- sets default shell to ``zsh``
- installs [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- adds plugin [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- adds plugin [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- sets theme [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- installs python pip packages (``virtualenv pygments``)
- adds some custom commands (``edt src cls``)

# Install

```bash
apt update && apt install -y curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/moozeq/ZSH_Setup/master/setup.sh)"
```