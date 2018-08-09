#!/usr/bin/env bash

PUBLIC_KEY=/vagrant/shared/.ssh/ssh-private-key.pub
AUTH_KEYS=/home/vagrant/.ssh/authorized_keys

if [[ -f $AUTH_KEYS ]]; then
    SPKE=$(cat $AUTH_KEYS | grep butuzov)
    if [[ -z $SPKE ]]; then
        cat $PUBLIC_KEY >> $AUTH_KEYS
    fi
fi


if [[ -d /shared ]]; then
    sudo chown jenkins:jenkins /vagrant/shared/.ssh
    sudo chown jenkins:jenkins /vagrant/shared/.ssh/ssh-private-key
    sudo chmod 0400 /vagrant/shared/.ssh/ssh-private-key
    sudo chmod 0400 /vagrant/shared/.ssh/ssh-private-key.pub
fi
