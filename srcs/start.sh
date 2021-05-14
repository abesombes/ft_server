#!/bin/bash

# LAUNCH OF PHP-FPM NGINX AND MYSQL
service php7.3-fpm start
service nginx start
service mysql start

# END OF PHPMYADMIN SETUP (CREATION OF PMA CONTROL USER)
chmod 755 /usr/share/phpmyadmin/sql/create_tables.sql
mysql -u root < /usr/share/phpmyadmin/sql/create_tables.sql
rm -rf /usr/share/phpmyadmin/sql/create_tables.sql
echo "GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'password'" | mysql -u root


# CREATION OF A WORDPRESS DATABASE IN MARIADB AND IMPORT OF THE SAMPLE WP DB WITH POSTS, COMMENTS ETC.
echo "CREATE DATABASE wordpress;" | mysql -u root                     
echo "CREATE USER 'wordpress'@localhost;" | mysql -u root           
echo "SET password FOR 'wordpress'@localhost = password('password');" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@localhost IDENTIFIED BY 'password';" | mysql -u root 
echo "FLUSH PRIVILEGES;" | mysql -u root 
mysql wordpress -u root < wordpress.sql
rm -rf wordpress.sql

# CREATION OF WORDPRESS VIRTUAL HOST ROOT PATH, DOWNLOAD AND EXTRACTION
while true; do
wget -T 15 -c "http://wordpress.org/latest.tar.gz" && break
done
tar xfvz latest.tar.gz
mv wordpress/* /usr/share/wordpress
rm -rf wordpress
ln -s /usr/share/wordpress /var/www/html/wordpress
mkdir /usr/share/wordpress/wp-content/uploads

# CONFIG OF WP ACCESS
chown -R www-data /usr/share/wordpress/wp-content/*
chmod -R 755 /usr/share/wordpress/wp-content/*

# PRINT OF NGINX ERROR AND ACCESS LOGS ON STDOUT
tail -f /var/log/nginx/access.log /var/log/nginx/error.log