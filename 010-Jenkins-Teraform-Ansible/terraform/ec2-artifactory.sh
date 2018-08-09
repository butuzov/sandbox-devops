#!/usr/bin/env bash

# installing java 1.8.0
sudo yum install java-1.8.0-openjdk-headless.x86_64 -y
sudo yum install java-1.8.0-openjdk-devel.x86_64 -y


sudo /usr/sbin/alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
sudo /usr/sbin/alternatives --set javac /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/javac

sudo /usr/sbin/alternatives --refresh javac
sudo /usr/sbin/alternatives --refresh java

# artifactory
curl -L -o jfrog-artifactory.rpm 'https://api.bintray.com/content/jfrog/artifactory-rpms/jfrog-artifactory-oss-$latest.rpm;bt_package=jfrog-artifactory-oss-rpm'
sudo rpm -i jfrog-artifactory.rpm

sudo chkconfig artifactory on
sudo service artifactory start
