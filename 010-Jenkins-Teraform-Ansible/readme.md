# Build Jenkins Pipeline for Java App

Next java app should be

- Compiled / Tested / Packaged
- Deployed to artifactory
- Build docker image with jar file and put it to docker registry (self hosted)
- Deploy it to production/staging using Ansible.

### Pipeline stages
  - setup
  - checkout
  - maven compile/test/build
  - artifactory to store app
  - build docker image
  - ansible deployment

### Deployment Specifications

For deployments was used personal domain made.ua and let's encrypt certificates (expired by now).

* [Deployment Environment - Terraform](010-Jenkins-Teraform-Ansible/terraform)
* [Deployment Environment - Vagrant](010-Jenkins-Teraform-Ansible/vagrant)

### Worning
This laboratory was moved form separate repository to own folder.
