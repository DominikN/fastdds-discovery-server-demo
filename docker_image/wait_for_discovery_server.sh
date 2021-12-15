#!/bin/bash

echo "Waiting for \"dds-discovery-server\" host to be available in /etc/hosts"

while [[ $(grep 'dds-discovery-server' /etc/hosts | wc -l) -eq 0 ]]; do 
    sleep 1
done

echo "\"dds-discovery-server\" present in /etc/hosts:"

# print the IPv6 address of the Discovery Server
grep 'dds-discovery-server' /etc/hosts

echo "Ready to launch ROS 2 nodes"

