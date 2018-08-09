# Kubernetes Lab 1

## [Original Code](https://github.com/andrewscat/kubelab)

In this lab you will create 2 pods with nginx inside, as well as service for each pod.
There also will be a config-map for each pod containing nginx config file, that will be mounted inside the pod.

Pods must be called:
 - nginx-1
 - nginx-2

Services must be called:
 - nginx-1-web
 - nginx-2-web

Config-maps must be called:
 - nginx-1-config
 - nginx-2-config

## Requirements

The following requirements must be satisfied:
 - only one mainifest file must be used, its name is `lab-1.yaml`
 - services must listen on port 80
 - nginx-1 must listen on port 8081
 - nginx-2 must listen on port 8082
 - nginx-1 must have a label `app: web-1`
 - nginx-2 must have a label `app: web-2`
 - pods must have installed `curl` inside

## Check

You can check your configuration with the following commands:

```bash
kubectl create -f 007-K8S-Hello-World/k8s-services.yaml
# wait for resources to be created
kubectl get pod nginx-1 --output=jsonpath={.metadata.labels.app}
kubectl get pod nginx-2 --output=jsonpath={.metadata.labels.app}
kubectl exec -ti nginx-1 -- curl --connect-timeout 2 -s nginx-1-web
kubectl exec -ti nginx-1 -- curl --connect-timeout 2 -s nginx-2-web
kubectl exec -ti nginx-1 -- curl --connect-timeout 2 -s nginx-1:8081
kubectl exec -ti nginx-2 -- curl --connect-timeout 2 -s nginx-1-web
kubectl exec -ti nginx-2 -- curl --connect-timeout 2 -s nginx-2-web
kubectl exec -ti nginx-2 -- curl --connect-timeout 2 -s nginx-1:8082
```

### WORNING

This code was moved into own directory. `Jenkinsfile` and `k8s-services.yaml` suppose to be in root directory of respository.

### Prerequisite

Build nginx container with curl inside.

```bash
docker build -t butuzov/nginx .
docker push butuzov/nginx
```
