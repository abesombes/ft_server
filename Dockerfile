FROM debian:buster
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget
RUN apt-get -y install nginx
RUN apt-get install vim -y
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-zip php-mbstring
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz
RUN tar xvf phpMyAdmin-5.1.0-english.tar.gz
RUN rm -rf phpMyAdmin-5.1.0-english.tar.gz
RUN mv phpMyAdmin-5.1.0-english /usr/share/phpmyadmin
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY srcs/nginx.conf /etc/nginx/sites-available/nginx.conf
COPY srcs/index.html /var/www/html/index.html
RUN rm /etc/nginx/sites-enabled/default
RUN	ln -fs /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
COPY srcs/*.sh ./
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt
CMD bash start.sh
