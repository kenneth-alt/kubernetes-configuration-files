#!/bin/bash
# Script Name: containerd installation script for Ubuntu
# Author: Kenneth-alt
# Date: last modified 17/10/2023
# Description: script to install containerd on k8s node on Ubuntu server

# disable memory swap
sudo swapoff -a

# setup prerequisites
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# install containerd CRI
sudo apt-get update
sudo apt-get -y install containerd

# create containerd config file and enable the SystemdCgroup
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd
