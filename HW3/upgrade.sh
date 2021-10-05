#!/bin/bash

# set one variable to current color and another to next color
OLD_COLOR=`curl http://192.168.33.10:2379/v2/keys/color/curr | jq -r .node.value`
if [[ "$OLD_COLOR" == "NONE" ]];then
	echo "Changing color to BLUE"
	NEW_COLOR="BLUE"
elif [[ "$OLD_COLOR" == "BLUE" ]];then
	echo "Changing color to GREEN"
	NEW_COLOR="GREEN"
else
	echo "Changing color to BLUE"
	NEW_COLOR="BLUE"
fi
OLD_COLOR=$OLD_COLOR

OLD_VERSION=`curl http://192.168.33.10:2379/v2/keys/version/curr | jq -r .node.value`
NEW_VERSION=$((OLD_VERSION+1))
OLD_VERSION=$OLD_VERSION

docker build -t flask_app_basic ./flask_app_"$NEW_VERSION"
docker run -d --rm -p :80 --name server_"$NEW_COLOR" flask_app_basic

./confd/run_confd.sh

sudo cp /home/vagrant/confd/out/nginx.conf /home/vagrant/nginx
sudo cp /home/vagrant/confd/out/nginx.conf /home/vagrant/nginx/etc_nginx

# if we are just booting up the first BLUE container
if [[ "$OLD_COLOR" == "NONE" ]];then
	echo "Booting up nginx"
	# build nginx
	./nginx/build_ngx.sh
	# boot up nginx
	./nginx/run_ngx.sh
# if we are upgrading from one color to another
else
	echo "Restarting nginx"
	docker container exec my-custom-nginx-container nginx -s reload
	docker stop server_"$OLD_COLOR"
	./remove_exited_containers.sh
fi

etcdctl set color/curr $NEW_COLOR
etcdctl set version/curr $NEW_VERSION
