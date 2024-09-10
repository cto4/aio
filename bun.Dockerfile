FROM alpine:3.20 AS bun

WORKDIR /app-ci
COPY ./src/scripts/bun.sh entrypoint.sh
ARG GLIBC_VERSION=2.34-r0

RUN apk add xz
RUN wget https://github.com/oven-sh/bun/releases/download/bun-v1.1.27/bun-linux-x64.zip && \
  unzip bun-linux-x64.zip && cd bun-linux-x64 && \
  tar cv bun | xz -f9 -T0 > /app-ci/bun.tar.xz && \
  cd .. && rm -rf bun-linux-x64* && \
  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" -P /tmp && \
  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" -P /tmp && \
  chmod 777 /app-ci/entrypoint.sh

FROM alpine:3.18

# Image info
LABEL maintainer="Ibrahim Megahed <tdim.dev@gmail.com>" \
  org.opencontainers.image.title="aio-server bun" \
  org.opencontainers.image.description="All In One server. custom Bun.sh Alpine Linux docker image." \
  org.opencontainers.image.authors="Ibrahim Megahed <tdim.dev@gmail.com>" \
  org.opencontainers.image.version="1.1.27" \
  architecture="amd64/x86_64" \
  build="11-Sep-2024"

# First setup - get bun & entrypoint
COPY --from=bun /app-ci /app-ci
WORKDIR /app-ci

# Disable the runtime transpiler cache by default inside Docker containers.
# On ephemeral containers, the cache is not useful
ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}

# Ensure `bun install -g` works
ARG BUN_INSTALL_BIN=/usr/local/bin
ENV BUN_INSTALL_BIN=${BUN_INSTALL_BIN}

# Final setup - prepare bun & glibc
RUN  --mount=type=bind,from=bun,source=/tmp,target=/tmp \
  addgroup -g 1000 bun && \
  adduser -u 1000 -G bun -s /bin/sh -D bun && \
  apk --no-cache --force-overwrite --allow-untrusted add /tmp/glibc*.apk

ENTRYPOINT [ "/app-ci/entrypoint.sh" ]
CMD [ "/app-ci/bun", "repl" ]