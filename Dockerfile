FROM debian:buster
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget libnss3-tools
COPY srcs/*.sh ./
RUN bash wget-mkcert.sh
RUN apt-get -y install net-tools nginx
RUN apt-get install vim -y
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php7.3-xml php-cli php-zip php-mbstring
RUN bash wget-phpmyadmin.sh
RUN mkdir usr/share/phpmyadmin/tmp
RUN chmod 777 usr/share/phpmyadmin/tmp
COPY srcs/config.inc.php usr/share/phpmyadmin/
COPY srcs/wp-config.php usr/share/wordpress/
COPY srcs/nginx.conf /etc/nginx/sites-available/localhost/
COPY srcs/index.html /var/www/html/index.html
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/localhost/nginx.conf /etc/nginx/sites-enabled/default
RUN chmod +x mkcert
RUN ./mkcert -install
RUN ./mkcert localhost
RUN mkdir /etc/nginx/ssl/
RUN mv *.pem /etc/nginx/ssl/
COPY srcs/wordpress.sql ./
CMD bash start.sh