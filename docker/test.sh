#!/bin/bash

EASYRSA='/usr/share/easy-rsa'
export PW='P@ssw0rd'

cd $EASYRSA

./easyrsa init-pki

expect -c '
spawn ./easyrsa build-ca
expect \"Enter\"
send {$env(PW)}
send \r
set timeout 30
expect \"Re-Enter\"
send {$env(PW)}
send \r
expect \"Common Name\"
send tuimac\r
expect eof
'

expect -c '
spawn ./easyrsa build-client-full client
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
#./easyrsa build-server-full server

rm -rf pki/
