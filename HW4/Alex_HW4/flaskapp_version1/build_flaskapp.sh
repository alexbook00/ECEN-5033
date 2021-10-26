sudo docker build -t alex-flaskapp:version1 .
sudo docker tag alex-flaskapp:version1 192.168.33.10:5000/alex-flaskapp:version1
sudo docker push 192.168.33.10:5000/alex-flaskapp:version1
