#!/bin/bash

# Assign environment variables to local variables
EFS_ID="${EFS_ID}"
DB_NAME="${DB_NAME}"
DB_HOSTNAME="${DB_HOSTNAME}"    
DB_USERNAME="${DB_USERNAME}"
DB_SECRET_ID="'${DB_SECRET_ID}'"
SUBDOMAIN="${SUBDOMAIN}"
WP_TITLE="${WP_TITLE}"
WP_ADMIN="${WP_ADMIN}"
WP_PASSWORD="${WP_PASSWORD}"
WP_EMAIL="${WP_EMAIL}"
AWS_REGION="${AWS_REGION}"
WP_VERSION="6.1"
LOCALE="en_GB"

sudo yum update -y
sudo yum install -y jq
sudo yum install -y httpd
sudo service httpd start
sudo yum install amazon-efs-utils -y

# Mounting Efs 
sudo mount -t efs -o tls ${EFS_ID}:/  /var/www/html

# Making Mount Permanent
echo "${EFS_ID}:/ /var/www/html efs tls,_netdev 0 0" | sudo tee -a /etc/fstab
sudo chmod go+rw /var/www/html

# Install PHP, and related packages
sudo yum remove -y php*
sudo yum clean -y all
sudo amazon-linux-extras enable php8.2 memcached1.5
sudo yum clean -y metadata
sudo yum install -q -y php php-gd php-mysqli php-cli php-fpm php-opcache php-common
sudo yum install -y php-xml
sudo yum install -y gcc make php php-pear php-devel libmemcached libmemcached-devel zlib-devel
sudo pecl update-channels

# Install and start Memcached
sudo yum install memcached -y
sudo systemctl start memcached
sudo systemctl enable memcached

# Install WP-CLI
sudo curl -o /bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x /bin/wp

# # Insert DB info to wordpress config file and install theme
# cd /var/www/html
# sudo wp core download --version="${WP_VERSION}" --locale="${LOCALE}" --allow-root

# #create wp-config.php
# echo "Generating wp-config.php...."
# wp config create --dbname="${DB_NAME}" --dbuser="${DB_USERNAME}" --dbpass="$(aws secretsmanager get-secret-value --secret-id "${DB_SECRET_ID}" --region "${AWS_REGION}" | jq -r .SecretString | jq -r .password)" --dbhost="${DB_HOSTNAME}" --allow-root

# echo "Installing Wordpress...."
# wp core install --url="https://${SUBDOMAIN}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN}" --admin_password="${WP_PASSWORD}" --admin_email="${WP_EMAIL}" --allow-root


# #Install w3-total cache plugin 
# wp plugin install w3-total-cache --activate --allow-root

# Restart httpd
sudo service httpd restart