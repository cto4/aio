FROM alpine:3.20

# Image info
LABEL maintainer="Ibrahim Megahed <tdim.dev@gmail.com>" \
    org.opencontainers.image.title="aio-server mariadb" \
    org.opencontainers.image.description="All In One server. apache2, php, phpmyadmin and mariadb in one Alpine Linux docker image." \
    org.opencontainers.image.authors="Ibrahim Megahed <tdim.dev@gmail.com>" \
    org.opencontainers.image.version="1.0.0" \
    architecture="amd64/x86_64" \
    build="23-Aug-2024"

# First setup
COPY . /app/source
WORKDIR /app

# Download packages, Install Later - just to keep image size small
RUN mkdir pkgs && \
    apk add --no-cache openrc && \
    # Main pkgs
    apk fetch --no-cache -R -o ./pkgs mariadb pwgen

# Final setup - restructure app directory
RUN rc-status -s && touch /run/openrc/softlevel && \
    mkdir /app/logs /app/pids && \
    chmod -R 777 /app/source/src/services && \
    cp -r /app/source/src/services/mariadb.sh /etc/init.d && \
    cp -r /app/source/src/scripts /app && \
    chmod -R 777 /app/scripts

VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 3306

ENTRYPOINT ["/app/scripts/entrypoint.sh", "mariadb"]