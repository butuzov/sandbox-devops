#!/usr/bin/env bash


PUBLIC_KEY=/.ssh/id_rsa.pub
AUTH_KEYS=/home/vagrant/.ssh/authorized_keys

if [[ -f $AUTH_KEYS ]]; then
    SPKE=$(cat $AUTH_KEYS | grep butuzov)
    if [[ -z $SPKE ]]; then
        cat $PUBLIC_KEY >> $AUTH_KEYS
    fi

    if [[ ! -f /home/vagrant/.ssh/id_rsa ]]; then
        cp /.ssh/id_rsa /home/vagrant/.ssh/id_rsa
    fi

fi

