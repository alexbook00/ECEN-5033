# Only run this on the master node

# (on first node) Create Cluster 
# add --dry-run to the end of the below command 
#  if you want to see what it would do without doing it
sudo kubeadm init --apiserver-advertise-address 192.168.33.10 --node-name machine1 --pod-network-cidr=10.244.0.0/16



# Copy config to homedir
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Deploy a pod network 
sudo kubectl apply -f kube-flannel.yml


