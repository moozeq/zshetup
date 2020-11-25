FROM ubuntu:latest

RUN apt update && apt install -y curl
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/moozeq/ZSH_Setup/master/setup.sh)"

CMD ["/bin/zsh"]