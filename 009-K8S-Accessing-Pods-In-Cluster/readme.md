# Kubernetes Lab 3

## [Original Code](https://github.com/andrewscat/kubelab)

In this lab you will create:
 - deployment running nginx
 - service for nginx called `web`

You can also use PersistentVolumeClaim since default StorageClass is already created for you. Consider also using init containers.

## Scenario

1. User replaces special value in `lab-3.yaml` with an url
2. User creates the kubernetes objects
3. User can see content of previously set url as a main page in nginx

## Requirements

- the manifest file should be called `lab-3.yaml`
- `lab-3.yaml` must contain special text `MAIN_PAGE`. This text will be replaced by sed with a random url (e.g. `http://www.linux.org.ru`)
- nginx must have as an index page the content of previously set url (even after the pod is restarted)
- nginx must have label `application: www`
- nginx container should contain `curl`
- only one nginx pod is allowed

## Check

```bash
set -e
RANDOM_URL="http://www.linux.org.ru"
curl ${RANDOM_URL} > url.html
sed -i -e "s|MAIN_PAGE|${RANDOM_URL}|" lab-3.yaml
kubectl create -f lab-3.yaml
# wait for resources to be created

test $(kubectl get pods -l application=www --no-headers | wc -l) -eq 1
kubectl exec -ti $(kubectl get pods -l application=www --output=jsonpath={.items..metadata.name}) curl web > main.html
diff url.html main.html

kubectl delete pods -l application=www
# wait for pods to be restarted

test $(kubectl get pods -l application=www --no-headers | wc -l) -eq 1
kubectl exec -ti $(kubectl get pods -l application=www --output=jsonpath={.items..metadata.name}) curl web > main.html
diff url.html main.html
```

### WORNING

This code was moved into own directory. `Jenkinsfile` and `k8s-services.yaml` suppose to be in root directory of respository.

### Prerequisite

Build alpine's curl image

```bash
docker build -t butuzov/curl .
docker push butuzov/curl
```
