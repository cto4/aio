#!/bin/sh
set -e

if [ -d /app-ci/pkgs ]; then
  apk add /app-ci/pkgs/*.apk
  rm -rf /app-ci/pkgs
fi

exec "$@"