FROM debian:buster

# Update, Upgrade, Download and Install of Wget && Libnss3-tools (for SSL Certificates)
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget libnss3-tools

# Copy of the sh scripts and Download of Mkcert (Generation of self-signed SSL Certificates)
COPY srcs/*.sh ./
RUN bash wget-mkcert.sh

# Install of Nginx, Vim, Mariadb and PHP7.3
RUN apt-get -y install net-tools nginx
RUN apt-get install vim -y
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php7.3-xml php-cli php-zip php-mbstring

# Download and install of PhpMyAdmin
RUN bash wget-phpmyadmin.sh
RUN mkdir usr/share/phpmyadmin/tmp
RUN chmod 777 usr/share/phpmyadmin/tmp
COPY srcs/config.inc.php usr/share/phpmyadmin/

# Copy of config files for Wordpress, Nginx and custom html index
COPY srcs/wp-config.php usr/share/wordpress/
COPY srcs/*.conf /etc/nginx/sites-available/localhost/
COPY srcs/index.html /var/www/html/index.html

# Creation of the symlink to the new nginx.conf file
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/localhost/nginx.conf /etc/nginx/sites-enabled/default

# Install of Mkcert and generation of SSL certificate and key
RUN chmod +x mkcert
RUN ./mkcert -install
RUN ./mkcert localhost
RUN mkdir /etc/nginx/ssl/
RUN mv *.pem /etc/nginx/ssl/

# Copy of the sample wordpress content (posts, comments for example)
COPY srcs/wordpress.sql ./

CMD bash start.sh