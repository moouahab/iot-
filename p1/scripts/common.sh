#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt update && apt upgrade -y

apt install -y \
  curl \
  wget \
  ca-certificates \
  gnupg \
  lsb-release \
  apt-transport-https \
  iptables \
  iptables-persistent \
  conntrack \
  socat \
  net-tools

# Désactiver swap (obligatoire pour Kubernetes)
swapoff -a
# Ne pas supprimer plusieurs fois : on commente les lignes swap si présentes
sed -i 's/^\(.*swap.*\)$/#\1/' /etc/fstab

# Activer modules réseau
modprobe br_netfilter
if ! grep -q '^br_netfilter$' /etc/modules; then
  echo "br_netfilter" >> /etc/modules
fi

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system
