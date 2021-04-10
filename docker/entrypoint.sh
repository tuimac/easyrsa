#!/bin/bash

CERTDIR='/root/certs'
EASYRSA='/usr/share/easy-rsa'
SERVERCERTNAME='server'
CLIENTCERTNAME='client'

function generateCaCert(){
    cd $EASYRSA
    ./easyrsa init-pki
    if [ $1 -eq 0 ]; then
        ./easyrsa --batch build-ca nopass
    else
		expect -c '
        set timeout 30
		spawn ./easyrsa build-ca
		expect \"Enter:\"
		send {$env(CAPASSWORD)}
		send \r
		expect \"Re-Enter:\"
		send {$env(CAPASSWORD)}
		send \r
		expect \"Common Name\"
		send tuimac\r
		expect eof
		'
    fi
}

function generateServerCert(){
    cd $EASYRSA
    if [ -z $SERVERPASSWORD ]; then
        ./easyrsa build-server-full ${SERVERCERTNAME} nopass
    else
        expect -c '
        spawn ./easyrsa build-server-full server
        expect \"Enter\"
        send {$env(PW)}
        send \r
        set timeout 30
        expect \"Verifying\"
        send {$env(PW)}
        send \r
        expect \"Enter pass phrase\"
        send {$env(PW)}
        send \r
        expect eof
        '
    fi
}

function generateCerts(){
    if [ -z $CAPASSWORD ]; then
        generateCaCert 0
    else
        generateCaCert 1
    fi
    generateServerCert
    ./easyrsa gen-dh
    openvpn --genkey --secret ${CERTDIR}/ta.key
    ./easyrsa build-client-full ${CLIENTCERTNAME} nopass
    mv ${EASYRSA}/pki/ca.crt ${SERVERDIR}
    mv ${EASYRSA}/pki/issued/${SERVERCERTNAME}.crt ${CERTDIR}
    mv ${EASYRSA}/pki/private/${SERVERCERTNAME}.key ${CERTDIR}
    mv ${EASYRSA}/pki/dh.pem ${CERTDIR}
    mv ${EASYRSA}/pki/issued/${CLIENTCERTNAME}.crt ${CERTDIR}
    mv ${EASYRSA}/pki/private/${CLIENTCERTNAME}.key ${CERTDIR}
}

function main{
    generateCerts
}

main
