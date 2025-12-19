# Cluster k3s via Vagrant

Ce dossier lance un cluster k3s minimal (1 serveur, 1 worker) dans deux VM Debian avec Vagrant + VirtualBox. Fonctionne sous Linux, macOS ou Windows tant que la virtualisation est activée.

## Prérequis
- Vagrant installé (https://developer.hashicorp.com/vagrant/downloads)
- VirtualBox 7.x installé (https://www.virtualbox.org/wiki/Downloads)
- Virtualisation activée dans le BIOS/UEFI (Windows/Linux) ou Hypervisor Framework actif (macOS)
- Espace disque libre (~2 Go) et connexion Internet pour le premier provisionnement
- Les VM utilisent 1 vCPU/1 Go chacune ; si k3s est à l’étroit, augmentez dans `Vagrantfile`.

## Démarrage
```bash
cd p1
vagrant up
```
Vagrant crée `moouahab_S` (serveur k3s) en 192.168.56.110 et `moouahab_SW` (worker) en 192.168.56.111.

## Vérifier le cluster
```bash
vagrant ssh moouahab_S -c "sudo kubectl get nodes -o wide"
```
Les deux nœuds doivent apparaître en `Ready`.
```bash
vagrant ssh moouahab_S -c "sudo kubectl get pods -A"
```
Tous les pods système doivent être en `Running` (jobs helm en `Completed`).

## Test rapide (optionnel)
```bash
vagrant ssh moouahab_S -c "kubectl create deploy hello --image=nginx"
vagrant ssh moouahab_S -c "kubectl expose deploy hello --type=NodePort --port=80"
vagrant ssh moouahab_S -c "kubectl get svc hello -o wide"
```
Accédez ensuite via `http://192.168.56.110:<nodePort>` ou `http://192.168.56.111:<nodePort>`.

## Arrêt / reset
- Arrêter sans détruire : `vagrant halt`
- Repartir de zéro : `vagrant destroy -f` puis `vagrant up`

## Notes
- Les IP privées 192.168.56.110/111 doivent être libres sur l’hôte ; ajustez-les dans `Vagrantfile` si collision.
- Les scripts de provisionnement sont idempotents : un `vagrant provision` ne casse pas l’installation existante.
- Dépendances installées automatiquement : `curl`, `wget`, `ca-certificates`, `gnupg`, `lsb-release`, `apt-transport-https`, `iptables`, `iptables-persistent`, `conntrack`, `socat`, `net-tools`, plus les tunings kernel (swap off, `br_netfilter`, sysctl).
