# TODO: 3-Tier Web App

This is 3 tier web app demo for Ansible-based deployment.

### What it does?

- Deploying development/production environment for web application
- SSL based (used pre generated wildcard certificates for made.com.ua)
- Target Platforms: CentOS 7 / Ubuntu 16.
- Virtualization: Vagrant

### Issues
- MySQL Master/Slave relication for Centos/7 isnt finished.
- MySQL Master/Slave relication for Ubuntu/16 works just once.

I haven't spend much time figuring out proper way to implement master/slave replication.

# Run it.
```bash
vagrant up
./inventory > hosts
ansible-playbook  play-books/play.yml -e env=production -l "ubuntu*"
ansible-playbook  play-books/play.yml -e env=staging -l "centos*"
```
