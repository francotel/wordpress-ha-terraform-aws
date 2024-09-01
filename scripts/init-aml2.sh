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
WP_VERSION="${WP_VERSION}"
LOCALE="${LOCALE}"

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
sudo amazon-linux-extras enable php8.2
sudo yum clean -y metadata
sudo yum install -q -y php php-{gd,cgi,mysqli,cli,fpm,opcache,pear,common,curl,mbstring,mysqlnd,gettext,bcmath,xml,intl,zip,imap}
sudo yum install -y gcc gcc-c++ make perl-core php-devel libmemcached libmemcached-devel zlib-devel pcre-devel

sudo pecl update-channels

# Install WP-CLI
sudo curl -o /bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x /bin/wp

wget https://elasticache-downloads.s3.amazonaws.com/ClusterClient/PHP-8.2/latest-64bit-X86-openssl1.1
tar -zxvf latest-64bit-X86-openssl1.1
sudo mv amazon-elasticache-cluster-client.so /usr/lib64/php/modules/
echo "extension=amazon-elasticache-cluster-client.so" | sudo tee --append /etc/php.ini
rm -rfv latest-64bit-X86-openssl1.1

echo "install openssl"
wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz
pwd
tar xvf openssl-1.1.1c.tar.gz
cd openssl-1.1.1c
./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)'
make
sudo make install
sudo ln -sf /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
sudo ln -sf /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1

# Insert DB info to wordpress config file and install theme
cd /var/www/html
sudo wp core download --version="${WP_VERSION}" --locale="${LOCALE}" --allow-root

#create wp-config.php
echo "Generating wp-config.php...."
wp config create --dbname="${DB_NAME}" --dbuser="${DB_USERNAME}" --dbpass="$(aws secretsmanager get-secret-value --secret-id "${DB_SECRET_ID}" --region "${AWS_REGION}" | jq -r .SecretString | jq -r .password)" --dbhost="${DB_HOSTNAME}" --allow-root --extra-php <<PHP 
if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https'){ \$_SERVER['HTTPS']='on'; }
PHP

echo "Installing Wordpress...."
wp core install --url="https://${SUBDOMAIN}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN}" --admin_password="${WP_PASSWORD}" --admin_email="${WP_EMAIL}" --allow-root
wp option update home "https://${SUBDOMAIN}" --allow-root
wp option update siteurl "https://${SUBDOMAIN}" --allow-root
wp config set WP_HOME "https://${SUBDOMAIN}" --allow-root
wp config set WP_SITEURL "https://${SUBDOMAIN}" --allow-root
wp config set FORCE_SSL_ADMIN true --allow-root
wp config set FORCE_SSL_LOGIN true --allow-root

#Install w3-total cache plugin 
wp plugin install w3-total-cache --activate --allow-root

sudo chown -R apache:apache /var/www/html

sudo systemctl restart httpd