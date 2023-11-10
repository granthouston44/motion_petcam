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

```
DOCKER_BUILDKIT=1 docker buildx build --push \
  -t granthouston44/motion:motionrpi \
  --platform linux/arm/v7 .
```
This command builds and pushes the image to your Docker Hub repository.

Running the Container

Automated Setup with Script
As an alternative to manual setup, you can use the provided script to prepare your Raspberry Pi and install Docker. This script will enable the camera interface, install necessary tools, load kernel modules, and add your user to the required groups.

Using the Setup Script
Clone the Repository:
Clone the repository to your Raspberry Pi:

sh
Copy code
git clone https://github.com/yourusername/yourrepository.git
Run the Setup Script:
Change to the cloned directory, make the script executable, and run it:

sh
Copy code
cd yourrepository
chmod +x setup_camera_docker.sh
./setup_camera_docker.sh
This script will perform all necessary actions to set up the camera and Docker.

Reboot the Raspberry Pi:
After the script has finished, reboot your Raspberry Pi to ensure all changes take effect:

sh
Copy code
sudo reboot
Pull the Docker Image (Optional):
If you also want the script to pull the Docker image, append these lines to the end of the setup_camera_docker.sh script:

sh
Copy code
echo "Pulling the Motion Docker image..."
docker pull granthouston44/motion:motionrpi
Now, when you run the script, it will also download the latest version of your Docker image.

Please note that the script requires an internet connection to download and install packages. Ensure that your Raspberry Pi is connected to the internet before running the script.

Run the container with the following command:


```
docker run --device /dev/video0:/dev/video0 -p 80:80 \
  -e NOIP_USERNAME='email' -e NOIP_PASSWORD='password' \
  -e MOTION_USERNAME='user' -e MOTION_PASSWORD='pass' \
  -d granthouston44/motion:motionrpi
```
Replace email, password, user, and pass with your actual No-IP credentials and Motion web interface credentials, respectively.

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

Support
If you need help or have any questions, please open an issue on the GitHub repository or contact the maintainer.

This README provides a general guide for setting up and running the Motion Docker container on a Raspberry Pi. It assumes a certain level of familiarity with the command line, Docker, and network configuration. Adjustments might be necessary based on the specific details of your setup.