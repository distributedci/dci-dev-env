#!/bin/sh

echo "Generating secrets"
envsubst < /etc/squid/secrets.conf.template > /etc/squid/secrets.conf
echo "Done."

echo "Generating self-signed certificate."
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
    -subj "/C=US/ST=NC/L=Raleigh/O=Red Hat/CN=Distributed CI" \
    -keyout /etc/squid/cert.key \
    -out /etc/squid/cert.crt
echo "Done."

exec "$@"
