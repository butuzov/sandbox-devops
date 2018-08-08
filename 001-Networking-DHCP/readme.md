# DHCP

Using Vagrant setup DHCP Server and Clients:
* One DHCP Server
* One client get IP by MAC address
* One client get IP automatically

After clients ready, save some trafic with `tcpdump`.



### Starting Up and Teest

```bash
# Preconfigured DHCP config will be copied during vagrant startup provisioning.
# expected ips
# server -> 192.168.60.4 (hardcoded in vagrantfile)
# client_mac -> 192.168.60.201 (mac address based ip)
# client_dyn_ip -> expected to be in range from 192.168.60.100 to 192.168.60.120
vagrant up

# tcpdump part
vagrant ssh server
# run it and ctrl+c to break.
[vagrant@dhcp] > sudo tcpdump -w /vagrant/tcpdump.pcap -i eth1

# back to host
scp -i .vagrant/machines/server/virtualbox/private_key -P 2222  vagrant@127.0.0.1:/vagrant/tcpdump.pcap .

# reading dump
tcpdump -r tcpdump.pcap
```


