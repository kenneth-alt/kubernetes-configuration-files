## Creating a CSR

1. Generate private key for the user
     openssl genrsa -out dev-tom.key 2048

2. Generate a vertificate signing request
    openssl req -new -key dev-tom.key -subj "/CN=tom" -out dev-tom.csr

3. The manifest file for CertificateSigningRequest takes the base64 encoded version of the csr we generated, so we convert the csr file to base64 encoded
    cat dev-tom.csr | base64 | tr -d "\n"

4. Apply the CSR config file
    kubectl apply -f dev-tom-csr.yaml

5. Now the csr request will be in a pending state
    kubectl get csr

6. Approve CSR
    kubectl certificate approve dev-tom(name in the request file)

7. Get the generated certificate and decode it since it will be in base64
    kubectl get csr dev-tom -o yaml
    echo 'copied encoded certificate value' | base64 decode > dev-tom.crt

## To authenticate with the cluster using the newly generated user certificate

    kubectl --server <server-IP>:6443 \
    --certifcate-authorithy /etc/kubernetes/pki/ca.crt \
    --client-certificate dev-tom.crt \
    --client-key dev-tom.key \
    get pod

    OR

    create a kubeconfig file for dev-tom user
    copy and edit the admin.conf file on ~/.kube/ directory
    replace the user, certificate and key data in the conf file (either reference the absolute path for the crt and key files, or base64 encode the content and paste directly, which is the better option).

    Tom can now use his conf file to authenticate with the cluster.

## Giving permssions to the user (authorization)

1. Create clusterRole (cluster wide access)
  kubectl create clusterrole dev-cr --verb=["*"],get,list,create,update,delete --resource=deployments.apps,pods,services --dry-run -o yaml > dev-cr.yml

2. Apply the clusterrole config file
  kubectl apply -f dev-cr.yml

3. Create clusterRoleBinding
  kubectl create clusterrolebinding dev-crb --clusterrole=dev-cr --user=tom --dry-run -o yaml > dev-crb.yml

4. Apply the clusterrolebinding config file
  kubectl apply -f dev-crb.yml

5. Check what permission the user now has
  kubectl auth can-i create pod --as tom

## Creating serviceaccounts for non-human users

1. Create serviceaccount
    kubectl create serviceaccount jenkins --dry-run=client -o yaml > jenkins-sa.yml (when serviceaccounts are created they come with a token which is a k8s secret by default, the value is base64 encoded)

    We can decode and save the token value as a linux variable, we can use this token to access the cluster.

    kubectl --server <server-IP>:6443 \
    --certifcate-authorithy /etc/kubernetes/pki/ca.crt \
    --token $token \
    get pod

    We can also use the token in a conf file, in place of the crt and key data

2. Creating roles (for access to only a particular namespace)
    kubectl create role cicd-role --verb=create,list,update --resource=deployments.apps,services --dry-run=client -o yaml > cicd-role.yml

    We have to explicitly specify the namespace the role applies to just below the role name, if it's not the default namespace.

3. Create RoleBinding
  kubectl create rolebinding cicd-rb --role=cicd-role --serviceaccount=default:jenkins --dry-run -o yaml > cicd-rb.yml

4. Check what permission the serviceaccount now has
  kubectl auth can-i create pod --as system:serviceaccount:<namespace>:<serviceaccountname> -n <namespace>