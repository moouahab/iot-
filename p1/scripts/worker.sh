#!/bin/bash
set -e

if systemctl is-active --quiet k3s-agent; then
  echo "K3s agent deja actif, on saute l'installation."
  exit 0
fi

while [ ! -f /vagrant/node-token ]; do
  sleep 2
done

TOKEN=$(cat /vagrant/node-token)

curl -sfL https://get.k3s.io | \
  K3S_URL=https://192.168.56.110:6443 \
  K3S_TOKEN=$TOKEN \
  sh -s - \
  --node-ip=192.168.56.111

echo "K3s WORKER OK"
