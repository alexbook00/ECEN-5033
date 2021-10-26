#!/bin/bash
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "manycurl.sh <IP-addr>"
    exit 1
fi

while true; 
  do curl $1; 
  sleep 1; 
done; 
