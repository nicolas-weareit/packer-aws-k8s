#!/bin/bash -eu
apt-get update
echo '==> Installing prerequites...'
apt-get install -y curl

#echo '==> Installing Docker'
#apt-get install -y docker.io

# echo '==> Installing kubectl kubeadm kubelet...'
#curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
#echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
#apt-get update
#apt-get install -y kubectl kubeadm kubelet
#echo 'source <(kubectl completion bash)' >>~/.bashrc

apt-get -y autoremove --purge
apt-get clean

echo "====> Shutting down the SSHD service and rebooting..."
systemctl stop sshd.service
nohup shutdown -r now < /dev/null > /dev/null 2>&1 &
sleep 120
exit 0