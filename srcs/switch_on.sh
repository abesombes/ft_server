#!/bin/bash
cp -f /etc/nginx/sites-available/localhost/nginx_on.conf /etc/nginx/sites-available/localhost/nginx.conf
service nginx restart