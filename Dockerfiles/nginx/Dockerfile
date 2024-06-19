# Use the official Nginx image compatible with ARM architecture
FROM arm32v7/nginx:latest as builder

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy the custom Nginx configuration template into the container
COPY nginx.conf.template /etc/nginx/conf.d/nginx.conf.template

# Environment variables for substitution
ARG DOMAIN_NAME

# Substitute environment variables in the Nginx configuration template
RUN sed -e "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/nginx.conf

# Second stage
FROM arm32v7/nginx:latest

# Copy the processed configuration file from the builder stage
COPY --from=builder /etc/nginx/conf.d/nginx.conf /etc/nginx/conf.d/nginx.conf

# Expose ports for HTTP and HTTPS
EXPOSE 80 443

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
