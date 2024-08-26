#!/bin/bash
yum update -y
yum install -y httpd 
systemctl start httpd
systemctl enable httpd

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
IPV4=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

# Crear el contenido HTML
hostname=$(hostname)
content="Deployed via Terraform\nHostname: $hostname\nIP-v4: $IPV4"

# Escribir el contenido en el archivo index.html
echo -e "$content" | sudo tee -a /var/www/html/index.html