#!/bin/bash
cp -f /etc/nginx/sites-available/localhost/nginx_on.conf /etc/nginx/sites-available/localhost/nginx.conf
service nginx restart
tail -f /var/log/nginx/access.log /var/log/nginx/error.log