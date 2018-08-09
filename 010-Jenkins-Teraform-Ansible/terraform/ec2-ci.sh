#!/usr/bin/env bash

#########################################################
# Installas Jenkins, Maven, Docker and Ansible
########################################################
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/7/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven

# New "1.8.0" Java
sudo yum install java-1.8.0-openjdk-headless.x86_64 -y
sudo yum install java-1.8.0-openjdk-devel.x86_64 -y

# updating java
sudo /usr/sbin/alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
sudo /usr/sbin/alternatives --set javac /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/javac

sudo /usr/sbin/alternatives --refresh javac
sudo /usr/sbin/alternatives --refresh java

# jenkins
sudo wget  -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y

# git
sudo yum install git -y

# installing docker
sudo yum install docker -y
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins

# Docker start
sudo service docker start
sudo chkconfig docker on

# Ansible
sudo python -m pip install --upgrade pip
sudo python -m pip install ansible

# Jenkins user to ansible role and private key
sudo chown jenkins:jenkins /home/ec2-user/ansible/private_key
sudo chmod jenkins:jenkins /home/ec2-user/ansible/private_key
sudo chown jenkins:jenkins /home/ec2-user/ansible
sudo mv /home/ec2-user/ansible /ansible
chmod 0400 /ansible/private_key

# jenkins plugins
sudo service jenkins start
sleep 60
curl http://127.0.0.1:8080
sleep 20
sudo service jenkins stop

. ~/install-jenkins-plugins.sh
sudo service jenkins start
sudo chkconfig jenkins on
