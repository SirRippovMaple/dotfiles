#!/bin/zsh
openssl enc -d -aes-256-cbc -in $1 -out ${1:0:-4}
