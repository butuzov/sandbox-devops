# 3 Tier App using Ansbile (.v1 from May 2018)

### Goal

Deploy "some" 3 tier app using ansible.

### History

This is initial version and first Ansible related stuff.

### Starting Up and Teest

```bash
# running application*, balancer and database hosts using vagrant
vagrant up

# generate ansible inventory file.
chmod +x ./vagrant-ansible-hosts.sh
./vagrant-ansible-hosts.sh > hosts

# Install ansible in virtual environment
# python version last time used 3.7
python3 -m venv .env
source .env/bin/activate
python3 -m pip install ansible

# Running ping command
sudo ansible all -i hosts -m ping -f 1

 # install and run everything
sudo ansible-playbook -i hosts roles/all-in-one.yml -f 2 -b
```

Visit [127.0.0.1:8080](http://127.0.0.1:8080) to see results


