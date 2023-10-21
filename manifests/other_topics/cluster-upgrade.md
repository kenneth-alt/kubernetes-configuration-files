## Upgrading the clsuter

upgrade the kubeadm

apt update
apt-cache madison kubeadm

apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.26.10-1.1 && \
apt-mark hold kubeadm

kubeadm upgrade plan

then run 

kubeadm upgrade apply <desired_version>  # this will upgrade the cluster and renew the certificates

** For worker nodes, only run

kubeadm upgrade node

However, this does not upgrade the kubelet and kubectl, we have to do these separately.

We have to drain the nodes while we upgrade the kubelet and hubectl, and then uncordon the nodes to make the schedulable once again.

kubectl drain <node-to-drain> --ignore-daemonsets

apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.26.10-1.1 kubectl=1.26.10-1.1 && \
apt-mark hold kubelet kubectl

sudo systemctl daemon-reload
sudo systemctl restart kubelet

kubectl uncordon <node-to-uncordon>

NB: The command to drain the workr nodes has to be run on the master.