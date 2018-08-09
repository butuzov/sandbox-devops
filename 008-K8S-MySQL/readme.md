# Kubernetes Lab 2

## [Original Code](https://github.com/andrewscat/kubelab)

In this lab you will create:
 - pod `mysql-client`, that includes mysql client package and git package
 - pod `mysql-server` with mysql server
 - shared secret for mysql server `mysql-password`
 - service `mysql`

Consider also using ClusterIP service for mysql-server.

## Scenario

1. User clones git repository with mysql script to `mysql-client` pod
2. User runs script from the cloned repo
3. User runs `select` query to make sure that the script has executed correctly

## Requirements

- The manifest file must be called `lab-2.yaml`
- `mysql-client` pod must have environment variable `$PASSWORD` that stores a root password for the database
- mysql-server must request 256 MB of memory and 100M of CPU
- mysql-client must request 64 MB of memory and 50M of CPU
- mysql-server must have label `role: server`
- mysql-client must have label `role: client`
- mysql-client must have git and mysql-client packages installed

## Check

You can check your configuration with the following commands:

```bash
set -e
kubectl create -f 008-K8S-MySQL/k8s-services.yaml
test $(kubectl get pods --no-headers mysql-client | wc -l) -eq 1
test $(kubectl get pods --no-headers mysql-server | wc -l) -eq 1

kubectl get pod -l role=server --output=jsonpath={.items..spec.containers[].resources.requests.cpu}
kubectl get pod -l role=server --output=jsonpath={.items..spec.containers[].resources.requests.memory}
kubectl get pod -l role=client --output=jsonpath={.items..spec.containers[].resources.requests.cpu}
kubectl get pod -l role=client --output=jsonpath={.items..spec.containers[].resources.requests.memory}

kubectl exec -ti mysql-client -- git clone https://github.com/andrewscat/kubelab.git kubelab
kubectl exec -ti mysql-client -- sh -c 'echo -n $(date +%s) > value.txt'
kubectl exec -ti mysql-client -- sh -c 'value=$(cat value.txt); sed -i "s/RANDOM_VALUE/${value}/" kubelab/lab-2/script.sql'
kubectl exec -ti mysql-client -- sh -c 'mysql -u root -p$PASSWORD -h mysql < kubelab/lab-2/script.sql'
kubectl exec -ti mysql-client -- sh -c 'value=$(cat value.txt); mysql -u root -p$PASSWORD -h mysql LAB -sN -r -e "SELECT kubeval FROM Kubelab" | grep $value'
```

### WORNING

This code was moved into own directory. `Jenkinsfile` and `k8s-services.yaml` suppose to be in root directory of respository.


### Prerequisite

Build multistage mysql client docker image for mysql-client pod.

```bash
docker build -t butuzov/mysql .
docker push butuzov/mysql
```
