sudo docker build -t alex-flaskapp:version2 .
sudo docker tag alex-flaskapp:version2 192.168.33.10:5000/alex-flaskapp:version2
sudo docker push 192.168.33.10:5000/alex-flaskapp:version2
