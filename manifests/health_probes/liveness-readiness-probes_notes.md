## Liveness probe

Tells K8s the status of the container inside the pod. LivenessProbe simply pings the application in time interval to see if it responds, if not k8s will restart the pod.

Exec probes
kubelet executes the specified command to check the health.

spec:
  containers: 
  - name: app
    image: nginx
    livenessProbe: 
      periodSeconds: 5
      exec:
        command: ["cat /tmp/healthy"]

TCP probes
kebelet makes probe connection at the node, not in the pod

spec:
  containers: 
  - name: app
    image: nginx
    livenessProbe: 
      periodSeconds: 5
      tcpSocket:
        port: 3000

HTTP probes
kubelet sends an HTTP request to specified port and path

spec:
  containers: 
  - name: app
    image: nginx
    livenessProbe: 
      periodSeconds: 5
      httpGet:
        path: /healthy
        port: 3000


## Readiness Probes

Let's k8s know that an application started successfully and ready to recieve traffic.

## Configure Liveness and readiness probes

