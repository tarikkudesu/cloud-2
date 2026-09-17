#!/bin/bash

set -eu

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ] || [ ! -f /etc/nginx/ssl/inception.key ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=MO/ST=KH/O=42/OU=42/CN=tamehri.42.fr" \
        -addext "subjectAltName=DNS:tamehri.42.fr,DNS:localhost,IP:127.0.0.1"
fi

exec nginx -g "daemon off;"
