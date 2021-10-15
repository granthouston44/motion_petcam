FROM raspbian/stretch:latest as base-image

RUN apt-get -y update && apt-get -y install motion && apt-get -y install make && apt-get -y install gcc \
&& mkdir -p /var/lib/noip

WORKDIR /var/lib/noip/
RUN --mount=type=secret,id=noip noip_creds="$(cat /run/secrets/noip_creds)" \
    && wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz \
    && mkdir noip_ && tar xfvz noip-duc-linux.tar.gz -C noip_ --strip-components 1 \
    && echo '/usr/local/bin/noip2' >> /etc/rc.local \
    && cd ./noip_ make install

# TODO::
# Find way to run 'make install' and pass values into the prompt

COPY motion.conf /etc/motion/motion.conf

# TODO::
# Look into buildkit for more secure way to store secrets 

RUN --mount=type=secret,id=auth_creds auth_creds="$(cat /run/secrets/auth_creds)" \
&& sed -i -r -e "s/;\sstream_authentication\\ username:password/stream_authentication\\ ${auth_creds}/g"  /etc/motion/motion.conf

VOLUME /mnt/motion
EXPOSE 8081
ENTRYPOINT ["motion"]