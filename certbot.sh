#!/bin/bash

# Define your domain name
DOMAIN="example.com"

# Install Certbot
echo "Installing Certbot..."
sudo apt-get update
sudo apt-get install -y certbot

# Obtain a certificate
echo "Obtaining SSL certificate for $DOMAIN..."
sudo certbot certonly --standalone -d $DOMAIN

# Set up a cron job for automatic renewal
(crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet") | crontab -

echo "SSL certificate setup complete."
