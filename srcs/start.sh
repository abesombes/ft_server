#!/bin/bash

# LAUNCH OF PHP-FPM NGINX AND MYSQL
service php7.3-fpm start
service nginx start
service mysql start

chmod 777 /usr/share/phpmyadmin/sql/create_tables.sql
mysql -u root < /usr/share/phpmyadmin/sql/create_tables.sql
echo "GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'password'" | mysql -u root


# CREATION OF A WORDPRESS DATABASE IN MARIADB
echo "CREATE DATABASE wordpress;" | mysql -u root                     
echo "CREATE USER 'wordpress'@localhost;" | mysql -u root           
echo "SET password FOR 'wordpress'@localhost = password('password');" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@localhost IDENTIFIED BY 'password';" | mysql -u root 
echo "FLUSH PRIVILEGES;" | mysql -u root 
mysql wordpress -u root < wordpress.sql
rm -rf wordpress.sql

# CREATION OF WORDPRESS VIRTUAL HOST ROOT PATH, DOWNLOAD AND EXTRACTION
wget http://wordpress.org/latest.tar.gz
tar xfvz latest.tar.gz
mv wordpress/* /usr/share/wordpress
ln -s /usr/share/wordpress /var/www/html/wordpress
mkdir /usr/share/wordpress/wp-content/uploads
chmod -R 777 /usr/share/wordpress/wp-content/uploads/
chmod -R 777 /us/share/wordpress/wp-content/plugins/
# Config Access
chown -R www-data /usr/share/wordpress/wp-content/*
chmod -R 755 /usr/share/wordpress/wp-content/*


tail -f /var/log/nginx/access.log /var/log/nginx/error.log