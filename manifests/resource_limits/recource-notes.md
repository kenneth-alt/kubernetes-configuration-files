## How to check resource limits of apps, using JSONPath

kubectl get pod -o jsonpath="{range .items[*]} {.metadata.name} {.spec.containers[*].resources} {'\n'}"