FROM ubuntu:14.04

MAINTAINER "Ernest Yang" <ernest.atheros@gmail.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive


ENV SIAB_VERSION=2.20 \
  SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
  SIAB_PORT=4200 \
  SIAB_ADDUSER=true \
  SIAB_USER=super \
  SIAB_USERID=1000 \
  SIAB_GROUP=super \
  SIAB_GROUPID=1000 \
  SIAB_PASSWORD=super \
  SIAB_SHELL=/bin/bash \
  SIAB_HOME=/home/super \
  SIAB_SUDO=false \
  SIAB_SSL=true \
  SIAB_SERVICE=/:LOGIN \
  SIAB_PKGS=none \
  SIAB_SCRIPT=none

ADD shellinabox_${SIAB_VERSION}_amd64.deb /root/



# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
#RUN dpkg -i  /root/shellinabox_${SIAB_VERSION}_amd64.deb && rm -f /root/*.deb


# customize console message
# /etc/update-motd.d/00-header
# /etc/update-motd.d/10-help-text
# ~/.bashrc

RUN apt-get update && apt-get install -y openssl curl openssh-client sudo \
	autoconf cpio bc build-essential gcc-multilib bison gettext flex patch texinfo lzma && \
  apt-get clean && \
  dpkg -i  /root/shellinabox_${SIAB_VERSION}_amd64.deb && rm -f /root/*.deb && \

  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  ln -sf '/etc/shellinabox/options-enabled/00+Black on White.css' \
    /etc/shellinabox/options-enabled/00+Black-on-White.css && \
  ln -sf '/etc/shellinabox/options-enabled/00_White On Black.css' \
    /etc/shellinabox/options-enabled/00_White-On-Black.css && \
  ln -sf '/etc/shellinabox/options-enabled/01+Color Terminal.css' \
    /etc/shellinabox/options-enabled/01+Color-Terminal.css

EXPOSE 4200

VOLUME /etc/shellinabox /var/log/supervisor /home

ADD assets/entrypoint.sh /usr/local/sbin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["shellinabox"]
