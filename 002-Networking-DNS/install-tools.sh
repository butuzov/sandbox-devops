echo "Installing Software" 
sudo yum install -y bind* > /dev/null 2>&1
sudo yum install -y net-tools > /dev/null 2>&1
sudo yum install -y iptables-service > /dev/null 2>&1
sudo systemctl stop firewalld > /dev/null 2>&1
sudo systemctl mask firewalld > /dev/null 2>&1
sudo systemctl enable   named > /dev/null 2>&1
sudo systemctl start    named > /dev/null 2>&1