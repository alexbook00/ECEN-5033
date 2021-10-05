#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "run-etcd1-machine <cluster_size> <machine_num>"
    echo "   cluster_size should be 1 or 3"
    echo "   machine_num should be 1, 2, or 3"
    exit 1
fi




ETCDCTL_API=2
TOKEN=token-01
CLUSTER_STATE=new
NAME_1=machine-1
NAME_2=machine-2
NAME_3=machine-3
HOST_1=192.168.33.10
HOST_2=192.168.33.11
HOST_3=192.168.33.12


let x=$2
let y=x-1

# For this machine
THIS_NAME=machine-$2
THIS_IP=192.168.33.1$y
THIS_CNAME=etcd-$2



if [ $1 -eq 3 ]; then
    CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
elif [ $1 -eq 1 ]; then
    CLUSTER=${THIS_NAME}=http://${THIS_IP}:2380
else
    echo "incorrect arguments provided"
    echo "run-etcd1-machine <cluster_size> <machine_num>"
    echo "   cluster_size should be 1 or 3"
    echo "   machine_num should be 1, 2, or 3"
    exit 1
fi



echo "Starting etcd for:"
echo $THIS_NAME
echo $THIS_IP
echo $THIS_CNAME
echo $CLUSTER


sudo docker run -d -v /usr/share/ca-certificates/:/etc/ssl/certs \
     -p 2380:2380 -p 2379:2379  \
     --name etcd quay.io/coreos/etcd:v2.3.8  \
     -name $THIS_CNAME  \
        --name ${THIS_NAME} \
        --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
        --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
        --initial-cluster ${CLUSTER} \
        --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
