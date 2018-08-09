sudo yum install docker -y
sudo usermod -aG docker ec2-user

sudo service docker start
sudo chkconfig docker on

sudo curl -L https://github.com/docker/compose/releases/download/1.21.1/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/bin/docker-compose > /dev/null

sudo chmod +x /usr/bin/docker-compose
docker pull registry:2.6.2

cd ~/registry && sudo docker-compose up -d
