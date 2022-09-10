#!/bin/bash -eu
apt-get update
echo '==> Installing prerequites...'
apt-get install -y curl

cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sysctl --system

echo '==> Installing kubectl kubeadm kubelet...'
apt-get install -y apt-transport-https ca-certificates
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubectl kubeadm kubelet
apt-mark hold kubelet kubeadm kubectl
echo 'source <(kubectl completion bash)' >>~/.bashrc

apt-get -y autoremove --purge
apt-get clean

echo "====> Shutting down the SSHD service and rebooting..."
systemctl stop sshd.service
nohup shutdown -r now < /dev/null > /dev/null 2>&1 &
sleep 120
exit 0