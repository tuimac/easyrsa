#!/bin/bash

CERTDIR='/root/certs'
EASYRSA='/usr/share/easy-rsa'
SERVERCERTNAME='server'
CLIENTCERTNAME='client'

function generateCerts(){
    cd $EASYRSA
    ./easyrsa init-pki
    if [ -z '$CAPASSWORD' ]; then
        ./easyrsa --batch build-ca nopass
    else
        ./easyrsa 
    ./easyrsa gen-dh
    openvpn --genkey --secret ${CERTDIR}/ta.key
    ./easyrsa build-server-full ${SERVERCERTNAME} nopass
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
