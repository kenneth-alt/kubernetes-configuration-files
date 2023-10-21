## k8s REST API

kubectl config view

we can see the credentials kubectl uses to access and authenticate with the cluster with the above command.

Other ways of accessing the cluster via the REST API

1. using the kubectl proxy (creates a reverse proxy on localhost)

kubectl proxy --port=8080 & 

now we can do a curl to http://localhost:8080/api/v1/namespaces/default/services

we can kill the reverse proxy by copying the process id and running the command:

kill <process_id>

## Accessing the k8s REST API without kubectl proxy

we have to create a serviceaccount for the non human user, create a role for the serviceaccount and a rolebinding

kubectl create serviceaccount <serviceaccount_name>

create a role using a yaml file

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]

kubectl create rolebinding script-rb --role=script-role --serviceaccount=default:my-script

To connect to the REST API using the serviceaccount we need to get the token

kubectl get serviceaccount my-script.yaml

Te token is a reference to the secret, so we can get the secret

kubect get secret <secret_name>  to get the token

we can put the base64 decoded value in a $TOKEN variable and the k8s werver url into a $SERVER variable.

now we can make a http request:

curl -X GET $SERVER/api --header "Authorization: Bearer $TOKEN" --cacert /etc/kubernetes/pki/ca.crt

we can use the --insecure flag if we are sure of the server

