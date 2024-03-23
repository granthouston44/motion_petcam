# Motion Docker Image for Raspberry Pi
This Docker image is designed to run the Motion video surveillance software on a Raspberry Pi, using a connected camera device. It integrates with No-IP for Dynamic DNS support and can be configured to use HTTPS via Nginx and Certbot for secure video streaming.

## Features
- Runs on Raspberry Pi with ARMv7 architecture.
- Integrates with No-IP for dynamic DNS service.
- Streams video from a connected camera.
- Supports HTTPS using Nginx and Let's Encrypt SSL certificates.

## Prerequisites
Before using this Docker image, ensure that:

- The Raspberry Pi OS is up to date.
- The camera is connected to the Raspberry Pi.
- The v4l2-ctl utility is installed to verify the camera setup.


## Building the Image
<sup> You can also pull the docker image directly - check further down for the dockerhub command </sup>

Build the Docker motion image using the following command (make sure you're in the same dir as the motion dockerfile):

```
DOCKER_BUILDKIT=1 docker buildx build --push \
  -t granthouston44/motion:motionrpi \
  --platform linux/arm/v7 .
```

This command builds and pushes the image to your Docker Hub repository.


## Pre-configuration Steps
### Domain Name Configuration
Update the nginx.conf file to include your domain name in the server block. This is crucial for the SSL certification process.

### SSL Certificate Setup with Certbot
#### Update the Certbot Script:
Before running the Certbot script, make sure to update it with your domain name.
### Run Certbot:
Execute the Certbot script to obtain SSL certificates before starting your Docker containers. This ensures Nginx can start correctly using the obtained certificates.

You'll also need to make sure that you update the nginx.conf and docker compose file with the correct path to the certificates:
located in /etc/letsencrypt/live/yourdomain.com

### Environment Variables for Docker Compose
Before running docker-compose up, export the required environment variables specified in your docker-compose.yml. For example:

```
export NOIP_USERNAME='your_email@example.com'
export NOIP_PASSWORD='your_noip_password'
export MOTION_USERNAME='motion_admin'
export MOTION_PASSWORD='motion_password'
```

## Running the Container with Docker Compose
### Docker Compose Setup
Use Docker Compose to manage the Motion service and an Nginx reverse proxy for SSL termination.

### Docker Compose File
Refer to the docker-compose.yml section below for an example configuration. Replace the necessary environment variables with your actual No-IP and Motion credentials.

```
version: '3'
services:
  motion:
    image: granthouston44/motion:motionrpi
    ports:
      - "8081:8081"
    environment:
      NOIP_USERNAME: '${NOIP_USERNAME}'
      NOIP_PASSWORD: '${NOIP_PASSWORD}'
      MOTION_USERNAME: '${MOTION_USERNAME}'
      MOTION_PASSWORD: '${MOTION_PASSWORD}'
    devices:
      - "/dev/video0:/dev/video0"

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - /etc/letsencrypt:/mnt/letsencrypt
    depends_on:
      - motion
```

## Running with Docker Compose
Make sure the volume mount paths are correctly set for both the nginx.conf and letsencrypt certs. 
Run the following command in the directory containing your docker-compose.yml:

```
docker-compose up -d
```

## Automated Pi Setup with Script
Use the provided script to prepare your Raspberry Pi and install Docker. This script will enable the camera interface, install necessary tools, load kernel modules, and add your user to the required groups.

### Using the Setup Script
Clone the repository to your Raspberry Pi and run the setup script:

```
cd motion_petcam
chmod +x ./scripts/setup_camera_docker.sh
./scripts/setup_camera_docker.sh
```

This script will perform all necessary actions to set up the camera and Docker.

### Reboot the Raspberry Pi

After the script has finished, reboot your Raspberry Pi to ensure all changes take effect:

```
sudo reboot
```

### Pull the Docker Image (Optional):


If you also want the script to pull the Docker image, append these lines to the end of the setup_camera_docker.sh script:

```
echo "Pulling the Motion Docker image..."
docker pull granthouston44/motion:motionrpi
```

Now, when you run the script, it will also download the latest version of your Docker image.

Please note that the script requires an internet connection to download and install packages. Ensure that your Raspberry Pi is connected to the internet before running the script.

Run the motion container with the following command:


```
docker run --device /dev/video0:/dev/video0 -p 8081:8081 \
  -e NOIP_USERNAME='email' -e NOIP_PASSWORD='password' \
  -e MOTION_USERNAME='user' -e MOTION_PASSWORD='pass' \
  -d granthouston44/motion:motionrpi
```

## Manual Pi Camera Setup:

Camera Module Setup on Raspberry Pi
To set up the camera module on your Raspberry Pi, follow these steps:

Install v4l-utils:

Update your package list and install v4l-utils:


```
sudo apt-get update
sudo apt-get install v4l-utils
```
Verify Camera Installation:

Use v4l2-ctl to list connected video devices:


```
v4l2-ctl --list-devices
```
The command output should list your camera's details, confirming that it is detected by the system.

Load Camera Drivers:

Load the bcm2835-v4l2 driver to ensure the camera is accessible:


```
sudo modprobe bcm2835-v4l2
echo "bcm2835-v4l2" | sudo tee -a /etc/modules
```
Enable Camera Hardware:

Run raspi-config to enable the camera interface:


```
sudo raspi-config
```
Go to Interfacing Options, select Camera, and enable it. Reboot your Raspberry Pi afterward.

Adjust Permissions:

Add your user to the video group to grant permission to access the camera:


```
sudo usermod -a -G video $USER
```
Log out and back in or reboot for the changes to take effect.

Check Camera in Container:

After the container starts, verify that /dev/video0 is accessible:


```
docker exec <container_name_or_id> ls -l /dev/video0
```
This ensures that the camera device is correctly passed through to the container.

Troubleshooting
If you encounter issues, ensure that:

The camera is properly connected and recognized by the Raspberry Pi.
The No-IP client (noip2) is running and correctly updating your public IP.
Port forwarding is correctly configured on your router.
For further assistance, consult the logs, check firewall settings, and verify port forwarding rules.


# Troubleshooting
If you encounter issues, ensure that the camera is properly connected, the No-IP client is running, and port forwarding is correctly configured on your router. For further assistance, consult the logs, check firewall settings, and verify port forwarding rules.

# Support
If you need help or have any questions, please open an issue on the GitHub repository or contact the maintainer.

