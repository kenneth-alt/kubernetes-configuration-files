## deploying resources to a particular cluster node using nodeName

apiVersion: v1
kind: Pod
metadata:
  name: myapp-node2
  labels:
    name: myapp
spec:
  containers:
  - name: myapp-nginx
    image: nginx
    resources:
      limits:
        memory: "64Mi"
        cpu: "100m"
    ports:
      - containerPort: 80
  nodeName: node2



## deploying with labels using nodeSelector

kubectl label node <node_name> <label=desired_label>

apiVersion: v1
kind: Pod-node2
metadata:
  name: myapp-cpu_high
  labels:
    name: myapp
spec:
  containers:
  - name: myapp-nginx
    image: nginx
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
  nodeSelectors: high_cpu


## deploying to specific node using nodeAffinity

apiVersion: v1
kind: Pod
metadata:
  name: myapp-nodeAffinity
  labels:
    name: myapp
spec:
  containers:
  - name: myapp
    image: nginx
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
affinity: 
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/os
          operator: In 
          values: 
          - linux
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: type
            operator: In
            values:
            - cpu


## Taints and Tolerations

Taint = rules defined on a node to prevent pods with specified labels from being scheduled on them.

Toleration = exceptions to the taint, we can cofigure specific pods to get schedules despite the taint.

Master nodes have taints on them, which is why we can't schedule pods on them. but static pods and deamonsets for example still schedules on the master despite the taint because they have toleration for the taint configured.

kubectl describe node -n kube-system master | grep Taints


apiVersion: v1
kind: Pod
metadata:
  name: pod-with-toleration
  labels:
    name: myapp
spec:
  containers:
  - name: myapp
    image: nginx
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
  tolerations:
  - operator: Exists
    effect: NoExecute
  nodeName: master


## Inter-pod Affinity and Anti-affinity


