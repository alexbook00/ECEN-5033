docker run -v /home/vagrant/confd/confd:/etc/confd -v /home/vagrant/confd/out:/tmp -it dockage/confd confd -onetime -backend etcd -node http://192.168.33.10:2379
