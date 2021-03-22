FROM debian:buster
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget
RUN apt-get -y install nginx
RUN apt-get install vim -y
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY srcs/nginx.conf /etc/nginx/sites-available/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN	ln -fs /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
COPY srcs/*.sh ./
EXPOSE 80 443
CMD bash start.sh