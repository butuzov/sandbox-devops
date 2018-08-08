#!/usr/bin/env bash

TYPE=$1

MASTER_IP=192.168.0.17
PUPPET_IP=192.168.0.18

IP=$([ $TYPE == "master" ] && echo $MASTER_IP || echo $PUPPET_IP)

echo "Setting up Network"
ifconfig eth1 $IP netmask 255.255.255.0 up
IP=$( ifconfig | grep "inet" | grep -v "inet6" | awk 'NR==2{print $2}')
sudo -s

echo "Configuring bind"
MASK=$(echo $MASTER_IP | sed -e "s/[0-9]\{1,\}$/0/g")

sudo -s
systemctl stop named

# Actual Installation
cd /vagrant/zones

NAMED=named.$TYPE.conf
cat named.conf > $NAMED

sed -i.bac -E "s/(listen-on port 53[[:space:]]+)\{(.*)}/\1{\2 $IP;} /g" $NAMED
sed -i.bac -E "s/(allow-query[[:space:]]+)\{ (localhost)/\1{ \2; $MASK\/24/g" $NAMED

if [[ $TYPE == "slave" ]]; then
    sed -i.bac -E "s/(allow-transfer[[:space:]]+)\{.*\};//g" $NAMED
fi

# copy changed configuration
cat zones.$TYPE.conf >> $NAMED
cat $NAMED > /etc/named.conf
sudo chgrp named /etc/named.conf
sudo chown root  /etc/named.conf

sudo cp vanilla.$TYPE.fwd.zone /var/named/vanilla.fwd.zone
sudo cp vanilla.$TYPE.rev.zone /var/named/vanilla.rev.zone
sudo chgrp named /var/named/vanilla*
sudo chown root  /var/named/vanilla*

named-checkzone vanilla.com /var/named/vanilla.fwd.zone
named-checkzone vanilla.com /var/named/vanilla.rev.zone
named-checkconf -z /etc/named.conf

systemctl start named
systemctl status named.service

echo "search vanilla.com" > /etc/resolv.conf
echo "nameserver $MASTER_IP" >> /etc/resolv.conf
echo "nameserver $PUPPET_IP" >> /etc/resolv.conf

dig vanilla.com

