## Contexts

Defines which user connects to which cluster in the kubeconfig.yaml file

To list all available contexts

    kubectl config get-contexts

To get the current context

    kubectl config current-context

To switch context

    kubectl config use-context <context_name>

To switch to a different user, but same cluster, define a context for the same cluster but the other user.

## Namesapaces in contexts

To set a default namespace using context

kubectl config set-context --current --namespace=<namespace_name>



