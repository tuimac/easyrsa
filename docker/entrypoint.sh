#!/bin/bash

CERTDIR='/root/certs'
EASYRSA='/usr/share/easy-rsa'

function generateCerts(){
    cd $EASYRSA
    ./easyrsa init-pki
    if [ -z $CAPASSWORD ]; then
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
    if [ -z $SERVERPASSWORD ]; then
        ./easyrsa build-server-full server nopass
    else
        expect -c '
        set timeout 30
        spawn ./easyrsa build-server-full server
        expect \"Enter PEM pass phrase\"
        send {$env(PW)}
        send \r
        expect \"Verifying - Enter PEM pass phrase\"
        send {$env(PW)}
        send \r
        expect \"Enter pass phrase\"
        send {$env(PW)}
        send \r
        expect eof
        '
    fi
    if [ -z $CLIENTPASSWORD ]; then
        ./easyrsa build-client-full client nopass
    else
        expect -c '
        set timeout 30
        spawn ./easyrsa build-client-full client
        expect \"Enter PEM pass phrase\"
        send {$env(CLIENTPASSWORD)}
        send \r
        expect \"Verifying - Enter PEM pass phrase\"
        send {$env(CLIENTPASSWORD)}
        send \r
        expect \"Enter pass phrase\"
        send {$env(PW)}
        send \r
        expect eof
        '
    fi
    ./easyrsa gen-dh
    openvpn --genkey --secret ${CERTDIR}/ta.key
    mv ${EASYRSA}/pki/ca.crt ${CERTDIR}
    mv ${EASYRSA}/pki/issued/server.crt ${CERTDIR}
    mv ${EASYRSA}/pki/private/server.key ${CERTDIR}
    mv ${EASYRSA}/pki/dh.pem ${CERTDIR}
    mv ${EASYRSA}/pki/issued/client.crt ${CERTDIR}
    mv ${EASYRSA}/pki/private/client.key ${CERTDIR}
}

function createOvpn(){
    cat <<EOF > ${CERTDIR}/client.ovpn
client
dev tun
proto udp
remote $PUBLICIP 443
resolv-retry infinite
nobind
persist-key
persist-tun
user nobody
group nobody
remote-cert-tls server
tls-client
comp-lzo
cipher AES-256-CBC
verb 4
tun-mtu 1500
key-direction 1
EOF
    echo '<ca>' >> ${CERTDIR}/client.ovpn
    cat ${CERTDIR}/ca.crt >> ${CERTDIR}/client.ovpn
    echo '</ca>' >> ${CERTDIR}/client.ovpn

    echo '<key>' >> ${CERTDIR}/client.ovpn
    cat ${CERTDIR}/client.key >> ${CERTDIR}/client.ovpn
    echo '</key>' >> ${CERTDIR}/client.ovpn

    echo '<cert>' >> ${CERTDIR}/client.ovpn
    cat ${CERTDIR}/client.crt >> ${CERTDIR}/client.ovpn
    echo '</cert>' >> ${CERTDIR}/client.ovpn

    echo '<tls-auth>' >> ${CERTDIR}/client.ovpn
    cat ${CERTDIR}/ta.key >> ${CERTDIR}/client.ovpn
    echo '</tls-auth>' >> ${CERTDIR}/client.ovpn
}

function packCerts(){
    cd ${CERTDIR}
    cd ..
    zip -r certification.zip ${CERTDIR}
}

function main(){
    generateCerts
    createOvpn
    packCerts
}

main
