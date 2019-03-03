FROM i386/alpine:3.9
MAINTAINER silverbolt28

# Set environment variables
ENV HOME /config
ENV WINEPREFIX /config/wine
ENV DISPLAY :0

# Install packages
RUN \
 echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
 echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
 echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
 apk upgrade --no-cache --available && \
 apk add --no-cache tzdata shadow xvfb x11vnc supervisor novnc bash openbox xterm wine

# Change nobody's uid, gid, home, and shell
RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /config nobody && \
 usermod -s /bin/ash nobody && \
 mkdir -p /config && \
 chown -R nobody:users /config

# Add supervisord.conf and modify includes
ADD supervisord.conf /etc/supervisor.d/supervisord.conf
RUN echo "files = /etc/supervisor.d/*.conf /config/supervisor.d/*.conf" >> /etc/supervisord.conf

# Volumes and ports
VOLUME /config
EXPOSE 8080

CMD ["/usr/bin/supervisord"]
