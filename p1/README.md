# Cluster k3s via Vagrant

Ce dossier lance un cluster k3s minimal (1 serveur, 1 worker) dans deux VM Debian avec Vagrant + VirtualBox. Fonctionne sous Linux, macOS ou Windows tant que la virtualisation est activée.

## Prérequis
- Vagrant installé (https://developer.hashicorp.com/vagrant/downloads)
- VirtualBox 7.x installé (https://www.virtualbox.org/wiki/Downloads)
- Virtualisation activée dans le BIOS/UEFI (Windows/Linux) ou Hypervisor Framework actif (macOS)
- Espace disque libre (~2 Go) et connexion Internet pour le premier provisionnement

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

## Arrêt / reset
- Arrêter sans détruire : `vagrant halt`
- Repartir de zéro : `vagrant destroy -f` puis `vagrant up`

## Notes
- Les IP privées 192.168.56.110/111 doivent être libres sur l’hôte ; ajustez-les dans `Vagrantfile` si collision.
- Les scripts de provisionnement sont idempotents : un `vagrant provision` ne casse pas l’installation existante.
