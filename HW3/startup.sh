#!/bin/bash

# boot up etcd
./run_etcd.sh 1 1
# boot up registrator
./run_reg.sh

# keep track of current color, set initial color to NONE
etcdctl mkdir color
etcdctl set color/curr NONE

# keep track of current version, set initial version to 0
etcdctl mkdir version
etcdctl set version/curr 0
