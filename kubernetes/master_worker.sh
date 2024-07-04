#!/usr/bin/bash

# Referral documentation: https://medium.com/@mehmetodabashi/installing-kubernetes-on-ubuntu-20-04-e49c43c63d0c

# Display help message
if [[ "$1" == "--help" || "$1" == "-h" || "$1" == "" ]]; then
  echo "  "
  echo "------------------------------------------------"
  echo "Usage $0 node_type kubernetes_version hostname"
  echo "node_type : Accepts master or worker"
  echo "kubernetes_version : Version you want to install"
  echo "hostname : Host name of the server"
  echo "--help, -h : Displays this help message"
  echo "------------------------------------------------"
  exit 0
fi

# Set the host name
echo -e "\nSet the host name \n"
sudo hostnamectl set-hostname "$3"
# Enabling kernel modules
echo -e "\nEnabling kernel modules \n"

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Enabling the modules
sudo modprobe overlay
sudo modprobe br_netfilter

# System level network configurations
echo -e "\nSystem level network configuration \n"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Applying sysctl parameters
sudo sysctl --system

# Installing containerd package
echo -e "\n Installing containerd \n"
sudo apt-get update && sudo apt-get install containerd

# Configuring containerd files
echo -e "\n configuring containerd files \n"
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart the containerd configuration
sudo systemctl restart containerd

# disable swap
# memory
sudo swapoff -a

# Install packages apt-transport-https and curl
echo -e "\n Installing apt-transport-https and curl"
sudo apt-get update && sudo apt-get install -y apt-transport-https curl ca-certificates gpg

# Install the apt-key.gpg file and add it to the apt-key module
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


# Install kubernetes tools and set them on hold not to update automatically
echo -e "\n Installing kubernetes tools \n"
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

if [[ "$1" == 'master' ]]; then
# ipaddress of the master server
echo -e "\n Getting ip address of the server \n"
private_ip=$(ec2metadata --local-ipv4)
echo -e "\n $private_ip\n"

# Initialize the cluster
echo -e "\nInitializing the cluster \n"
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version $2

# Configure user's kubeconfig file manage cluster
echo -e "\n Configure the users kubeconfig file \n"
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Checks the installation is success or not
kubectl get nodes

# Add the network configuration
echo -e "\nApply network configuration \n"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

# Token creation for joining the worker nodes
kubeadm token create --print-join-command > join_token.txt

elif [ $1 == "worker" ]; then
  sudo $(cat ./join_token.txt)
fi