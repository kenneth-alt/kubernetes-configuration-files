## etcd

Key-Value that stores:

configuration and state of all components we've deployed.
revisions and deployment history
configmap and secrets data

Application data is not stored in etcd, we need volumes for this.

## Creating etcd backup

install etcdctl on the master, and use it to create the etcd backup.

sudo apt install etcd-client

etcdctl needs to be authenticated using certficates. we can check how etcd communicates with the cluster here:
sudo cat /etc/kubernetes/manifests/etcd.yaml

 We grab the ca.crt, server.crt, and server.key file locations, like below:

sudo ETCDCTL_API=3 etcdctl snapshot save /tmp/snapshot.db \
- --cacert /etc/kubernetes/pki/etcd/ca.crt \
- --cert /etc/kubernetes/pki/etcd/server.crt \
- --key /etc/kubernetes/pki/etcd/server.key 

We can check the status of the snapshot

sudo ETCDCTL_API=3 etcdctl snapshot status /tmp/snapshot.db --write-out=table


## etcd Remote storage

Options: Configure remote storage for the etcd data outside the cluster such as aws s3, or on-prem storage,
          Run etcd outside the k8s cluster.


## Restore cluster from etcd backup

sudo ETCDCTL_API=3 etcdctl snapshot restore /tmp/snapshot.db --data-dir /var/lib/etcd-backup 

Now we have two folders in the /var/lib for etcd, now we make etcd use the backed up filder since the other folder has been corrupted.

vi /etc/kubernetes/manifests/ectd.yaml and change the hostPath to the new location, only the hostPath and not the mountPath.

We can check the status of the snapshot

sudo ETCDCTL_API=3 etcdctl snapshot status /tmp/snapshot.db --write-out=table