FROM debian:buster
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget libnss3-tools
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
RUN apt-get -y install net-tools nginx
RUN apt-get install vim -y
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-zip php-mbstring
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz
RUN tar xvf phpMyAdmin-5.1.0-english.tar.gz
RUN rm -rf phpMyAdmin-5.1.0-english.tar.gz
RUN mv phpMyAdmin-5.1.0-english /usr/share/phpmyadmin
COPY srcs/nginx.conf /etc/nginx/sites-available/localhost/
RUN mkdir -p /var/www/localhost
COPY srcs/index.html /var/www/localhost/index.html
RUN rm /etc/nginx/sites-enabled/default
RUN ln -fs /etc/nginx/sites-available/localhost/ /etc/nginx/sites-enabled/
COPY srcs/*.sh ./
RUN chmod +x mkcert
RUN ./mkcert -install
RUN ./mkcert localhost
RUN mkdir /etc/nginx/ssl/
RUN mv *.pem /etc/nginx/ssl/
ENTRYPOINT ["tail", "-f", "/dev/null"]