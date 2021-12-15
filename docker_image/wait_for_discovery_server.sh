#!/bin/bash

echo "Waiting for \"ddsdiscoveryserver\" host to be available in /etc/hosts"

while [[ $(grep 'ddsdiscoveryserver' /etc/hosts | wc -l) -eq 0 ]]; do 
    sleep 1
done

echo "\"ddsdiscoveryserver\" present in /etc/hosts:"

# print the IPv6 address of the Discovery Server
grep 'ddsdiscoveryserver' /etc/hosts