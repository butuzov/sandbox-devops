#!/usr/bin/env bash

# echo "Running system updates using yum"
# yum update -y                       > /dev/null 2>&1


# Java and Company
echo "Running installation: Java, Jenkins, Maven and Artifactory"
yum install java -y                 > /dev/null 2>&1

JENKINS_REPO=https://pkg.jenkins.io/redhat-stable/jenkins.repo
if  [[ ! -f /etc/yum.repos.d/$(basename ${JENKINS_REPO}) ]]; then
    echo "Action: Jenkins repo install"
	curl -L ${JENKINS_REPO} -o /etc/yum.repos.d/$(basename ${JENKINS_REPO})
	rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
fi

yum install maven git jenkins -y    > /dev/null 2>&1
chkconfig jenkins on                > /dev/null 2>&1
systemctl start jenkins             > /dev/null 2>&1

# Jenkins Plugins
cd /vagrant/shared/jenkins
chmod +x ./install.sh
./install.sh
cd /vagrant/
systemctl restart jenkins             > /dev/null 2>&1

# Artifactory
if [[ ! -d /opt/jfrog/artifactory ]]; then
    curl -L -o jfrog-artifactory.rpm 'https://api.bintray.com/content/jfrog/artifactory-rpms/jfrog-artifactory-oss-$latest.rpm;bt_package=jfrog-artifactory-oss-rpm'
	yum install -y net-tools        > /dev/null 2>&1
	rpm -i jfrog-artifactory.rpm
    unlink jfrog-artifactory.rpm
    systemctl enable artifactory
fi
systemctl start artifactory


# ansible
echo "Running installation: Ansible and python's pip"
yum install epel-release -y          > /dev/null 2>&1
yum install python-pip -y            > /dev/null 2>&1
python -m pip install --upgrade pip  > /dev/null 2>&1
python -m pip install ansible        > /dev/null 2>&1




# Docker
echo "Running installation: Docker, Compose and Regsitry"
DOCKER_EXISTS=$(which docker)
if [[ -z $DOCKER_EXISTS ]]; then
    curl -fsSL https://get.docker.com/ | sh  > /dev/null 2>&1
	usermod -aG docker $(whoami)
    usermod -aG docker jenkins
    usermod -aG docker root
    systemctl enable docker
fi

systemctl start docker

# Docker Registry
docker pull docker.io/registry:2.6.2 > /dev/null 2>&1

# Docker Compose
python -m pip install docker-compose > /dev/null 2>&1
