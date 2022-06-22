#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo yum -y install git
sudo systemctl start httpd
sudo systemctl enable httpd
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
cd /var/www/html/
sudo rm index.html
cd /home/ec2-user/
sudo git clone https://github.com/prafulpatel16/php-html-projects.git
sudo cp -r php-html-projects/iPortfoliov1_emp/* /var/www/html/                                        