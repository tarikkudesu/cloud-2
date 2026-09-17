#!/bin/bash
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
chmod -R 755 /var/www/html
cd /var/www/html

cat <<EOF > /etc/php/8.4/fpm/pool.d/zzz.conf 
[www]
listen = 9000
EOF

for ((i = 1; i <= 10; i++)); do
    if mariadb -h mariadb -P 3306 \
        -u "${INCEPTION_MYSQL_USER}" \
        -p"${INCEPTION_MYSQL_PASS}" -e "SELECT 1" > /dev/null 2>&1; then
        break
    else
        sleep 2
    fi
done

wp core download --allow-root
wp config create \
    --dbname=${INCEPTION_MYSQL_DATABASE} \
    --dbuser=${INCEPTION_MYSQL_USER} \
    --dbpass=${INCEPTION_MYSQL_PASS} \
    --dbhost=mariadb:3306 --allow-root
wp core install \
    --url=${INCEPTION_DOMAIN_NAME} \
    --title=${INCEPTION_WP_TITLE} \
    --admin_user=${INCEPTION_WP_A_NAME} \
    --admin_password=${INCEPTION_WP_A_PASS} \
    --admin_email=${INCEPTION_WP_A_EMAIL} --allow-root
wp user create ${INCEPTION_WP_U_NAME} ${INCEPTION_WP_U_EMAIL} \
    --user_pass=${INCEPTION_WP_U_PASS} \
    --role=${INCEPTION_WP_U_ROLE} --allow-root

wp theme install twentytwentyfour --activate --allow-root
chown -R www-data:www-data /var/www/html

mkdir -p /run/php
exec php-fpm8.4 -F
