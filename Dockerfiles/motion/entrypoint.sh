#!/bin/bash

# Navigate to the No-IP directory, run make and install No-IP using the expect script
cd /usr/local/src/noip
./configure-noip.expect "$NOIP_USERNAME" "$NOIP_PASSWORD"

# Check if noip2 is running and start it if not
if ! pgrep -x "noip2" > /dev/null
then
    echo "Starting No-IP Client..."
    noip2
else
    echo "No-IP Client is already running."
fi

# Configure Motion with authentication credentials
sed -i "s/stream_authentication username:password/stream_authentication $MOTION_USERNAME:$MOTION_PASSWORD/g" /etc/motion/motion.conf

# Start Motion
motion -c /etc/motion/motion.conf
