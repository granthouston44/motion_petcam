Motion Docker Image for Raspberry Pi
This Docker image is designed to run the Motion video surveillance software on a Raspberry Pi, using a connected camera device and integrating with No-IP for Dynamic DNS support.

Features
Runs on Raspberry Pi with ARMv7 architecture.
Integrates with No-IP for dynamic DNS service.
Streams video from a connected camera.
Prerequisites
Before using this Docker image, ensure that:

The Raspberry Pi OS is up to date.
The camera is connected to the Raspberry Pi.
The v4l2-ctl utility is installed to verify the camera setup.
Building the Image
Build the Docker image using the following command:

sh
Copy code
DOCKER_BUILDKIT=1 docker buildx build --push \
  -t granthouston44/motion:motionrpi \
  --platform linux/arm/v7 .
This command builds and pushes the image to your Docker Hub repository.

Running the Container
Run the container with the following command:

sh
Copy code
docker run --device /dev/video0:/dev/video0 -p 80:80 \
  -e NOIP_USERNAME='email' -e NOIP_PASSWORD='password' \
  -e MOTION_USERNAME='user' -e MOTION_PASSWORD='pass' \
  -d granthouston44/motion:motionrpi
Replace email, password, user, and pass with your actual No-IP credentials and Motion web interface credentials, respectively.

Camera Module Setup on Raspberry Pi
To set up the camera module on your Raspberry Pi, follow these steps:

Install v4l-utils:

Update your package list and install v4l-utils:

sh
Copy code
sudo apt-get update
sudo apt-get install v4l-utils
Verify Camera Installation:

Use v4l2-ctl to list connected video devices:

sh
Copy code
v4l2-ctl --list-devices
The command output should list your camera's details, confirming that it is detected by the system.

Load Camera Drivers:

Load the bcm2835-v4l2 driver to ensure the camera is accessible:

sh
Copy code
sudo modprobe bcm2835-v4l2
echo "bcm2835-v4l2" | sudo tee -a /etc/modules
Enable Camera Hardware:

Run raspi-config to enable the camera interface:

sh
Copy code
sudo raspi-config
Go to Interfacing Options, select Camera, and enable it. Reboot your Raspberry Pi afterward.

Adjust Permissions:

Add your user to the video group to grant permission to access the camera:

sh
Copy code
sudo usermod -a -G video $USER
Log out and back in or reboot for the changes to take effect.

Check Camera in Container:

After the container starts, verify that /dev/video0 is accessible:

sh
Copy code
docker exec <container_name_or_id> ls -l /dev/video0
This ensures that the camera device is correctly passed through to the container.

Troubleshooting
If you encounter issues, ensure that:

The camera is properly connected and recognized by the Raspberry Pi.
The No-IP client (noip2) is running and correctly updating your public IP.
Port forwarding is correctly configured on your router.
For further assistance, consult the logs, check firewall settings, and verify port forwarding rules.

Support
If you need help or have any questions, please open an issue on the GitHub repository or contact the maintainer.

This README provides a general guide for setting up and running the Motion Docker container on a Raspberry Pi. It assumes a certain level of familiarity with the command line, Docker, and network configuration. Adjustments might be necessary based on the specific details of your setup.