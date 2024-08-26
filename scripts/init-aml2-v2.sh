#!/bin/bash

# Inicio del cronómetro
start_time=$(date +%s)

# Aquí va todo tu script

# Ejemplo de comando para loggear el inicio
echo "Inicio de ejecución: $(date)" | sudo tee -a /var/log/user_data_execution_time.log

# Variables de entorno
EFS_ID="${EFS_ID}"
DB_NAME="${DB_NAME}"
DB_HOSTNAME="${DB_HOSTNAME}"    
DB_USERNAME="${DB_USERNAME}"
DB_SECRET_ID="${DB_SECRET_ID}"
SUBDOMAIN="${SUBDOMAIN}"
WP_TITLE="${WP_TITLE}"
WP_ADMIN="${WP_ADMIN}"
WP_PASSWORD="${WP_PASSWORD}"
WP_EMAIL="${WP_EMAIL}"
AWS_REGION="${AWS_REGION}"
WP_VERSION="6.1"
LOCALE="en_GB"

# Función para obtener contraseña desde AWS Secrets Manager
# get_db_password() {
#     aws secretsmanager get-secret-value --secret-id "${DB_SECRET_ID}" --region "${AWS_REGION}" | jq -r .SecretString | jq -r .password
# }

# Actualizar e instalar paquetes necesarios
sudo yum update -y
sudo yum install -y jq httpd amazon-efs-utils rsync memcached php php-gd php-mysqli php-cli php-fpm php-opcache php-common php-xml gcc make php-pear php-devel libmemcached libmemcached-devel zlib-devel
sudo amazon-linux-extras enable php8.2 memcached1.5
sudo yum clean all
sudo pecl update-channels

# Iniciar servicios necesarios
sudo service httpd start
sudo systemctl start memcached
sudo systemctl enable memcached

# Montar EFS
sudo mount -t efs -o tls ${EFS_ID}:/ /var/www/html
echo "${EFS_ID}:/ /var/www/html efs tls,_netdev 0 0" | sudo tee -a /etc/fstab
sudo chmod go+rw /var/www/html

# Sincronizar archivos si es necesario
if [ -d "/var/www/html/wp-content" ]; then
    echo "Sincronizando archivos de WordPress..."
    sudo rsync -a /var/www/html/wp-content/ /var/www/html/ --delete
fi

# Instalar WP-CLI
if ! command -v wp &> /dev/null; then
    echo "Instalando WP-CLI..."
    sudo curl -o /bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    sudo chmod +x /bin/wp
fi

# Verificar si WordPress ya está instalado
cd /var/www/html
if [ ! -f wp-config.php ]; then
    echo "Generando wp-config.php...."
    wp config create --dbname="${DB_NAME}" --dbuser="${DB_USERNAME}" --dbpass="$(aws secretsmanager get-secret-value --secret-id "${DB_SECRET_ID}" --region "${AWS_REGION}" | jq -r .SecretString | jq -r .password)" --dbhost="${DB_HOSTNAME}" --locale="${LOCALE}" --allow-root
fi

# Instalar o actualizar WordPress
if ! wp core is-installed --allow-root; then
    echo "Instalando WordPress...."
    wp core install --url="https://${SUBDOMAIN}" --title="${WP_TITLE}" --admin_user="${WP_ADMIN}" --admin_password="${WP_PASSWORD}" --admin_email="${WP_EMAIL}" --allow-root
else
    echo "WordPress ya está instalado. Verificando actualizaciones...."
    wp core update --version="${WP_VERSION}" --allow-root
fi

# Instalar y activar plugin de caché
if ! wp plugin is-installed w3-total-cache --allow-root; then
    wp plugin install w3-total-cache --activate --allow-root
else
    wp plugin activate w3-total-cache --allow-root
fi

# Reiniciar Apache
sudo service httpd restart

# Fin del cronómetro
end_time=$(date +%s)

# Calcular el tiempo total de ejecución
execution_time=$((end_time - start_time))
echo "Tiempo total de ejecución del user data: ${execution_time} segundos" | sudo tee -a /var/log/user_data_execution_time.log
