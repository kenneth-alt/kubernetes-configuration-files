## Storage Requirements

should not depend on pod lifecycle
must be available on all nodes
needs high availability to survive even if the enrire cluster crashes

## Persistent volume and Persistent volume claim

Pod requests the volume through PV claim
Claim tries to find a volume in the cluster
PV will have the actual storage backend

PVC must be in the same namespace as the pod using it.
PV are not namespace and are available to the entire cluster

## ConfigMaps and secrets

Are also volumes (local volumes)


## Storage Class

Provisions PV dynamically, when PVC claims it