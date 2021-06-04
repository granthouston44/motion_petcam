FROM debian

RUN apt-get update && apt-get -y upgrade \
&& apt-get install -y wget \ 
&& apt-get install -y motion \
&& apt-get install -y nano


RUN sed -i -r "s/start_motion_daemon=yes/start_motion_daemon=no/g" /etc/default/motion

ARG username
ARG password

RUN sed -i -r -e "s/daemon\\ off/daemon\\ on/g ; s/;logfile/logfile/g ; s/width\\ 320/width\\ 1024/g ; s/height\\ 240/height\\ 768/g ; s/webcontrol_port\\ 0/webcontrol_port\\ 8081/g ; s/;\\ webcontrol_authentication\\ username:password/webcontrol_authentication\\ ${username}:${password}/g"  /etc/motion/motion.conf   

RUN mkdir -p /var/lib/noip 
WORKDIR /var/lib/noip/
RUN wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz && \
    mkdir noip_ && tar xfvz noip-duc-linux.tar.gz -C noip_ --strip-components 1 \
    && echo '/usr/local/bin/noip2' >> /etc/rc.local

