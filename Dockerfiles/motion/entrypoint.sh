#!/bin/bash

# Navigate to the No-IP directory, run make and install No-IP using the expect script
cd /usr/local/src/noip
./configure-noip.expect "$NOIP_USERNAME" "$NOIP_PASSWORD"

# Configure Motion with authentication credentials
sed -i "s/stream_authentication username:password/stream_authentication $MOTION_USERNAME:$MOTION_PASSWORD/g" /etc/motion/motion.conf

# Start Motion
motion -c /etc/motion/motion.conf
