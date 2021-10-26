sudo docker build -t alex-ubuntucurl .
sudo docker tag alex-ubuntucurl 192.168.33.10:5000/alex-ubuntucurl
sudo docker push 192.168.33.10:5000/alex-ubuntucurl
