FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y curl
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/moozeq/zshetup/master/setup.sh)"

CMD ["/bin/zsh"]
