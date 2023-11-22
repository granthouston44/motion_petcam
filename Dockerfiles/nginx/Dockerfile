# Use the official Nginx image compatible with ARM architecture
FROM arm32v7/nginx:latest

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy the custom Nginx configuration file into the container
COPY nginx.conf /etc/nginx/conf.d/

VOLUME /mnt/letsencrypt/

# Expose ports for HTTP and HTTPS
EXPOSE 80 443

# Start Nginx when the container launches
# CMD ["nginx", "-g", "daemon off;"]
CMD ["/bin/sh"]
