
docker buildx build --push --build-arg username=username --build-arg password=passwprd -t granthouston44/motion:rpi . --platform linux/arm/v7

docker run -d --device=/dev/video0:/dev/video0 -p 8081:8081 granthouston44/motion:rpi