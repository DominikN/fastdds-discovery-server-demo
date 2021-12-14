#!/bin/bash

echo "Waiting for ddsdiscoveryserver device to be available in /etc/hosts"

while [[ $(grep 'ddsdiscoveryserver' /etc/hosts | wc -l) -eq 0 ]]; do 
    echo "."
    sleep 1
done

echo "ddsdiscoveryserver present in /etc/hosts"