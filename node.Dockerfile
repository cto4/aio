FROM alpine:3.20

# Image info
LABEL maintainer="Ibrahim Megahed <tdim.dev@gmail.com>" \
  org.opencontainers.image.title="aio-server node" \
  org.opencontainers.image.description="All In One server. custom Node.js Alpine Linux docker image." \
  org.opencontainers.image.authors="Ibrahim Megahed <tdim.dev@gmail.com>" \
  org.opencontainers.image.version="21.7.3" \
  architecture="amd64/x86_64" \
  build="11-Sep-2024"

# First setup
WORKDIR /app-ci
COPY ./src/scripts/node.sh entrypoint.sh

# Final setup - prepare nodejs
RUN mkdir pkgs && \
  apk fetch --update --no-cache -R -o ./pkgs nodejs-current npm icu-data-full && \
  chmod 777 /app-ci/entrypoint.sh && \
  addgroup -g 1000 node && \
  adduser -u 1000 -G node -s /bin/sh -D node

ENTRYPOINT [ "/app-ci/entrypoint.sh" ]
CMD [ "/usr/bin/node" ]