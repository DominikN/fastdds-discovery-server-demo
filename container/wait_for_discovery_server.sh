#!/bin/bash

while [[ $(grep 'ddsdiscoveryserver' /etc/hosts | wc -l) -eq 0 ]]; do 
    echo "."
    sleep 1
done

echo "DDS Discovery Server host is available (in /etc/hosts)"