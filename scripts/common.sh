#!/bin/bash
set -e

apt update && apt upgrade -y

apt install -y \
  curl \
  wget \
  ca-certificates \
  gnupg \
  lsb-release \
  apt-transport-https

# Désactiver swap (obligatoire pour Kubernetes)
swapoff -a
sed -i '/swap/d' /etc/fstab

# Activer modules réseau
modprobe br_netfilter
echo "br_netfilter" >> /etc/modules

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system
