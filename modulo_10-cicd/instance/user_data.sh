#! /bin/bash

# System update
sudo yum update

# Install pre-requisits
sudo yum install -y ruby wget

# Install AWS CodeDeploy Agent
cd ~
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo rm -f ./install 

# Install Apache
sudo yum install -y httpd
sudo systemctl enable --now httpd
