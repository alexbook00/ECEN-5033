#!/bin/bash

sudo docker run -d --rm \
    --name=registrator \
    --net=host \
    --volume=/var/run/docker.sock:/tmp/docker.sock \
    gliderlabs/registrator:latest \
    --ip=192.168.33.10 \
      etcd://192.168.33.10:2379
