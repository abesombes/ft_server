#!/bin/bash
# DOWNLOAD OF PHPMYADMIN AND EXTRACTION

mkdir -p usr/share/phpmyadmin

while true; do
wget -O phpmyadmin.tar.gz -T 15 -c "https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz" && break
done

tar xfvz phpmyadmin.tar.gz --strip-components 1 -C usr/share/phpmyadmin

rm -rf phpmyadmin.tar.gz

ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin