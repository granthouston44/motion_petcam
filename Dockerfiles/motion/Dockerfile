# syntax=docker/dockerfile:1.0.0-experimental

FROM dtcooper/raspberrypi-os:bullseye

# Install motion and other necessary packages
RUN apt-get update && \
    apt-get install -y \
    motion \
    make \
    gcc \
    wget \
    expect \
    procps \
    vim \ 
    curl

# Clean up the apt cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Download No-IP client, unpack it and prepare it for runtime installation
RUN wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz \
    && mkdir -p /usr/local/src/noip \
    && tar xfvz noip-duc-linux.tar.gz -C /usr/local/src/noip --strip-components=1 \
    && rm noip-duc-linux.tar.gz

# Copy the expect script and entrypoint script to the image
COPY configure-noip.expect /usr/local/src/noip/configure-noip.expect
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /usr/local/src/noip/configure-noip.expect \
    && chmod +x /entrypoint.sh

# Copy your motion configuration
COPY motion.conf /etc/motion/motion.conf

# Expose the port motion listens to
EXPOSE 8081

ENTRYPOINT ["/entrypoint.sh"]
