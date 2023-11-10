#!/bin/bash

# Exit if any command fails
set -e

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    # Add the current user to the docker group to avoid using 'sudo' with Docker
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed."
fi

# Install v4l2-utils if not already installed
if ! command -v v4l2-ctl &> /dev/null; then
    echo "Installing v4l2-utils..."
    sudo apt-get install -y v4l-utils
else
    echo "v4l2-utils is already installed."
fi

# Load bcm2835-v4l2 module
echo "Loading bcm2835-v4l2 module..."
if ! lsmod | grep -q "bcm2835_v4l2"; then
    sudo modprobe bcm2835-v4l2
    echo "bcm2835-v4l2" | sudo tee -a /etc/modules > /dev/null
else
    echo "bcm2835-v4l2 module is already loaded."
fi

# Enable camera
echo "Enabling the camera..."
if ! sudo raspi-config nonint get_camera | grep -q "0"; then
    sudo raspi-config nonint do_camera 0
    echo "Camera is now enabled."
else
    echo "Camera is already enabled."
fi

# Add user to video group
echo "Adding the current user to the video group..."
sudo usermod -a -G video $USER

# Cleanup Docker installation script
if [ -f get-docker.sh ]; then
    rm get-docker.sh
fi

echo "Setup is complete. Please reboot your Raspberry Pi to apply changes."
echo "NOTE: You will need to log out and log back in for the 'docker' group changes to take effect, or you can reboot your system."
