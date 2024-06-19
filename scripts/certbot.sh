#!/bin/bash

# Check if DOMAIN_NAME is set
if [ -z "$DOMAIN_NAME" ]; then
  echo "DOMAIN_NAME environment variable is not set."
  exit 1
fi

# Install Certbot
echo "Installing Certbot..."
sudo apt-get update
sudo apt-get install -y certbot

# Create the webroot directory and set permissions
sudo mkdir -p /var/www/certbot
sudo chown -R www-data:www-data /var/www/certbot
sudo chmod -R 755 /var/www/certbot

# Obtain a certificate
echo "Obtaining SSL certificate for $DOMAIN_NAME..."
sudo certbot certonly --webroot -w /var/www/certbot -d $DOMAIN_NAME

# Create the renewal script
echo "Creating renewal script..."
sudo tee "$(dirname "$0")/renew_cert.sh" > /dev/null <<EOF
#!/bin/bash
# Renew the certificate using the webroot method
sudo certbot renew --webroot -w /var/www/certbot

# Reload Nginx to apply the new certificate
docker-compose -f "$(dirname "$0")/../docker-compose.yml" exec nginx nginx -s reload
EOF

# Make the renewal script executable
sudo chmod +x "$(dirname "$0")/renew_cert.sh"

# Set up a cron job for automatic renewal
(crontab -l 2>/dev/null; echo "0 3 1 */2 * $(dirname "$0")/renew_cert.sh >> /var/log/renew_cert.log 2>&1") | crontab -

echo "SSL certificate setup complete."
