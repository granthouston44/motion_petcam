# Use the official Nginx image compatible with ARM64 architecture
FROM arm64v8/nginx:latest

# Remove the default Nginx configuration file
RUN rm /etc/nginx/nginx.conf

# Create the directory for ACME challenge files
RUN mkdir -p /var/www/certbot && chown www-data:www-data /var/www/certbot

# Copy the Nginx configuration template into the container
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Environment variables for substitution
ARG DOMAIN_NAME

# Substitute environment variables in the Nginx configuration template using sed
RUN sed -e "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Expose ports for HTTP and HTTPS
EXPOSE 80 443

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
