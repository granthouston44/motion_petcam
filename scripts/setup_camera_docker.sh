#!/bin/bash

# Function to check if a command succeeded
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed to execute successfully."
        exit 1
    fi
}

# Exit if any command fails
set -e

# Update package list
echo "Updating package list..."
sudo apt-get update
check_status "Package list update"

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    check_status "Docker installation"
    # Add the current user to the docker group to avoid using 'sudo' with Docker
    sudo usermod -aG docker $USER
    check_status "Adding user to Docker group"
else
    echo "Docker is already installed."
fi

# Install Docker Compose
echo "Installing Docker Compose..."
sudo apt-get install -y python3-pip libffi-dev
check_status "Dependency installation for Docker Compose"
sudo apt install docker-compose
check_status "Docker Compose installation"

# Install v4l2-utils if not already installed
if ! command -v v4l2-ctl &> /dev/null; then
    echo "Installing v4l2-utils..."
    sudo apt-get install -y v4l-utils
    check_status "v4l2-utils installation"
else
    echo "v4l2-utils is already installed."
fi

# Load bcm2835-v4l2 module
echo "Loading bcm2835-v4l2 module..."
if ! lsmod | grep -q "bcm2835_v4l2"; then
    sudo modprobe bcm2835-v4l2
    check_status "bcm2835-v4l2 module loading"
    echo "bcm2835-v4l2" | sudo tee -a /etc/modules > /dev/null
    check_status "Adding bcm2835-v4l2 module to load on boot"
else
    echo "bcm2835-v4l2 module is already loaded."
fi

# Enable camera
echo "Enabling the camera..."
if ! sudo raspi-config nonint get_camera | grep -q "0"; then
    sudo raspi-config nonint do_camera 0
    check_status "Camera enabling"
    echo "Camera is now enabled."
else
    echo "Camera is already enabled."
fi

# Add user to video group
echo "Adding the current user to the video group..."
sudo usermod -a -G video $USER
check_status "Adding user to video group"

# Cleanup Docker installation script
if [ -f get-docker.sh ]; then
    rm get-docker.sh
fi

echo "Setup is complete. Please reboot your Raspberry Pi to apply changes."
echo "NOTE: You will need to log out and log back in for the 'docker' group changes to take effect, or you can reboot your system."
