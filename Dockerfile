FROM debian:buster
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget libnss3-tools
COPY srcs/*.sh ./
RUN bash wget-mkcert.sh
RUN apt-get -y install net-tools nginx
RUN apt-get install vim -y
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-zip php-mbstring
RUN bash wget-phpmyadmin.sh
RUN tar xvf phpMyAdmin-5.1.0-english.tar.gz
RUN rm -rf phpMyAdmin-5.1.0-english.tar.gz
RUN mv phpMyAdmin-5.1.0-english /usr/share/phpmyadmin
COPY srcs/nginx.conf /etc/nginx/sites-available/localhost/
COPY srcs/index.html /var/www/html/index.html
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/localhost/nginx.conf /etc/nginx/sites-enabled/default
RUN chmod +x mkcert
RUN ./mkcert -install
RUN ./mkcert localhost
RUN mkdir /etc/nginx/ssl/
RUN mv *.pem /etc/nginx/ssl/
CMD bash start.sh