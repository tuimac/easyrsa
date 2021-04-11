#!/bin/bash

if [[ $1 == "--mode=web" ]]; then
    while true; do
        echo 'hello'
        sleep 10
    done
    #git clone https://github.com/tuimac/easyrsa
    #cd easyrsa/easyrsa
    #python3 manage.py runserver 0:8000
else
    bash /root/gen-certs.sh
fi
