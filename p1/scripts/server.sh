#!/bin/bash
set -e

if systemctl is-active --quiet k3s; then
  echo "K3s deja installe, on saute l'installation."
  exit 0
fi

curl -sfL https://get.k3s.io | sh -s - \
  --node-ip=192.168.56.110 \
  --write-kubeconfig-mode=644

sleep 10

# Partage du token pour le worker
cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token

# Installer kubectl
if ! command -v kubectl >/dev/null 2>&1; then
  curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi

echo "K3s SERVER OK"
