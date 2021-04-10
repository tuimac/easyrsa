#!/bin/bash

EASYRSA='/usr/share/easy-rsa'
PW='P@ssw0rd'

cd $EASYRSA


expect -c "
set timeout 5
spawn ./easyrsa build ca
"
