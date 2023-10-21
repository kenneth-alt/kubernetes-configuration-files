## Deployment strategies

1. Recreate strategy - removes all existing pods and then creates new one, this causes a downtime.

2. Rolling Update - Removes and replaces the pods one by one in a rolling fashion.

## Rollout
Every rollout creates a revision, we can check them with this command:

kubectl rollout history deployment <deployment_name>

## Rollback
we can rollback to a previous revision, with this command:

kubectl rollout undo deployment <deployment_name>
