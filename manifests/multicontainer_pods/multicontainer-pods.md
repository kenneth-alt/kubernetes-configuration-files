## Init and Sidecar containers

Init container runs once in the beginning, eg to set env variables

Sidecar runs in parrallel to the main container, eg to collect logs, keep the pod alive, preserve namesapce, etc