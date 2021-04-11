FROM alpine:latest

WORKDIR /root

ADD entrypoint.sh /root/entrypoint.sh
ADD gen-certs.sh /root/gen-certs.sh

RUN apk update && \
    apk upgrade && \
    apk add --no-cache git bash vim curl ncurses easy-rsa expect zip openvpn openjdk11 maven && \
    mkdir /etc/vim/backup && \
    mkdir /etc/vim/undo && \
    rm /etc/vim/vimrc && \
    curl -L https://raw.githubusercontent.com/tuimac/tools/master/vim/vimrc -o /etc/vim/vimrc && \
    curl -L https://raw.githubusercontent.com/tuimac/tools/master/linux/bashrc/.bashrc_node_docker -o /root/.bashrc && \
    git clone https://github.com/tuimac/easyrsa

ENTRYPOINT ["/root/entrypoint.sh"]
