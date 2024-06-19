# Use the official Nginx image compatible with ARM64 architecture
FROM arm64v8/nginx:latest

# Remove the default configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Create the directory for ACME challenge files
RUN mkdir -p /var/www/certbot && chown www-data:www-data /var/www/certbot

# Copy the main Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the server configuration template into the container
COPY server.conf.template /etc/nginx/conf.d/server.conf.template

# Environment variables for substitution
ARG DOMAIN_NAME

# Substitute environment variables in the server configuration template using sed
RUN sed -e "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" /etc/nginx/conf.d/server.conf.template > /etc/nginx/conf.d/server.conf

# Expose ports for HTTP and HTTPS
EXPOSE 80 443

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
