## Trobleshooting steps for applications

1. is the pod running?
    kubectl get pod <pod_name>

2. is the pod registered with the service? is the service forwarding the request?
    kubectl get ep
    kubectl describe service <service_name>

3. is the service accessible when you hit the endpoint?
    nc <service-IP>:<service-PORT>
    ping <service_name>

4. Check Application logs
    kubectl logs <pod_name>  (if the container is not running or crashing, you may not get any logs)

5. Check pod status and recent events
    kubectl describe pod <pod_name>

## debugging with temporary pods

Busybox image (packaged with debugging tools eg. ifconfig, nslookup, netstat, ping, etc. for debugging the pod network)
Curl image (busybox does not have curl, so we can install the curl image)

  kubectl run debug-pod --image=busybox

Containers only live as long as the process running inside them, we can use commands and args to keep them running.

To keep busybox alive:
   1. attach an interactive terminal
   kubectl run debug-pod --image=busybox -it 

   2. use a definition file and overwrite the CMD instruction or add an argument with ENTRYPOINT command.
      In the pod definition in k8s we can overwrite the ENTRYPOINT with an attribute called "command" and CMD with "args" like below:

        apiVersion: v1
        kind: Pod
        metadata:
          name: busybox-pod
        spec:
          containers:
          - name: busybox-container
            image: busybox
            command: ["sh"]
            args: ["-c", "sleep 1000"]

Execute a command without entering the pod, passing the command along with the run command
  kubectl exec -it <pod_name> -- sh -c "desired_command"
  eg. kubectl exec -it busybox-pod -- sh -c "while true; do echo hello; sleep 5; done"

## Efficiency tips: kubectl format output with JSONPath and custom columns

We can output components in yaml or json, but the files can be long and painstaking to go through, we can use JSONPath, a querry language for JSON, it uses expressions to filter for specific fields.

1. With JSONPath
  kubectl get pod -o jsonpath='{range .items[*].metadata.name}{"\n"}{end}'

  kubectl get pod -o jsonpath='{range .items[*].metadata.name}{"\t"}{.status.podIP}{"\n"}{end}'

  Tip: We can write scripts with our most commonly used expressions ans use them when we have to.

2. With custom-column (provides a more clear table with headings)
  kubectl get pod -o custom-columns=POD_NAME:.metadata.name,POD_IP:.status.podIP,CREATED_AT:.status.startTime


# Troubleshooting kubelet and kubectl issues

1. eg node not ready (could be a problem with the kubelet, remember that kubelet is a linux process)
  service kubelet status

  journalctl -u kubelet

  which kubelet (to find where the kubelet binary is located)

  specify the correct location of the kubelet conf file

  and reload the daemon: sudo systemctl daemon-reload


2. kubectl not working
   kubectl cluster-info
   verify that the certificate-authority(decode base64) in the ~/.kube/admin.conf is same with the one in the /etc/kubernetes/pki/ca.crt
    kubectl config view (validate that the master node IP is correct)


