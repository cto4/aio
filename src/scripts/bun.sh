#!/bin/sh
set -e

if [ -f /app-ci/bun.tar.xz ]; then
  tar xf /app-ci/bun.tar.xz -C /app-ci
  ln -s /app-ci/bun $BUN_INSTALL_BIN/bun
  ln -s /app-ci/bun $BUN_INSTALL_BIN/bunx
  rm -rf /app-ci/bun.tar.xz
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- /app-ci/bun "$@"
fi

exec "$@"