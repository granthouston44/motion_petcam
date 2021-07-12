FROM debian as base-image

#RUN sed -i -r "s/start_motion_daemon=yes/start_motion_daemon=yes/g" /etc/default/motion

# TODO::create motion user to run motion

RUN apt-get -y update \
&& apt-get install -y wget \
&& mkdir -p /var/lib/noip

WORKDIR /var/lib/noip/
RUN wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz && \
    mkdir noip_ && tar xfvz noip-duc-linux.tar.gz -C noip_ --strip-components 1 \
    && echo '/usr/local/bin/noip2' >> /etc/rc.local

FROM debian as build

COPY --from=base-image /var/lib/noip/noip_ /var/lib/noip/noip_

RUN apt-get -y update \
&& apt-get install -y motion \
&& apt-get install -y nano \
&& apt-get install -y make \
&& apt-get install -y gcc

ARG username
ARG password

RUN sed -i -r -e "s/daemon\\ off/daemon\\ on/g ; s/;logfile/logfile/g ; s/width\\ 320/width\\ 1024/g ; s/height\\ 240/height\\ 768/g ; s/webcontrol_port\\ 0/webcontrol_port\\ 8081/g ; s/;\\ webcontrol_authentication\\ username:password/webcontrol_authentication\\ ${username}:${password}/g"  /etc/motion/motion.conf

#v4l2-ctl --list-devices

# TODO::

# Find a way to keep the docker container running with both noip and motion processes
# Find a way to pass usb device in either using privilege or device flags
