# Vegrant powered CentOS environment

This `Vagrantfile` and provisioners will create/provision `master` node with Jenkins/Maven/Artifactory/Docker and Docker-Registry. The `slave` node partially provisioned just with ssh keys (its latter to be provisioned with ansible from `master` node).


# Technical

* __master__ node (ip: `192.168.10.9`, host: `registry.made.ua`
  (certs valid for 3 month since July 22th and used for `docker registry`) )
* __slave__ node (ip: `192.168.10.6`)

# Deployments

* QA [127.0.0.1:8092 within virtualbox: 192.168.10.6:8092](http://127.0.0.1:8092)
* Dev [127.0.0.1:8091 within virtualbox: 192.168.10.6:8091](http://127.0.0.1:8091)
* Prod [127.0.0.1:8090 within virtualbox: 192.168.10.6:8090](http://127.0.0.1:8090)

## Required Manual Tweaks

* Configuring Jenkins:
  * Artifactory ( Manage Jenkins -> Configure System -> **Artifactory** ):
    - Server ID: `artifactory`
    - URL: http://127.0.0.1:8081/artifactory
    - Default user (`admin/password`)
    - Default repository (no need to provide, but its hardcoded in Jenkinsfile)
  * Maven/Ansible/Docker ( Manage Jenkins -> Configure Tools):
    - Docker  { location : `/bin` }
    - Ansible { location : `/bin` }
    - Git     { location : `/bin` }
    - Maven (provide your version of `maven`)
* Create Multibranch Job for this repos.
* And we ready to go!
