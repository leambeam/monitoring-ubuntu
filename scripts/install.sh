#!/usr/bin/env sh
# Install prometheus tools
# usage: ./install.sh VERSION ARCH TOOL; run with sudo/as root
set -eu

usage="usage: ./install.sh VERSION ARCH TOOL"
VERSION=${1:?${usage}}
ARCH=${2:?${usage}}
TOOL=${3:?${usage}}
NAME="${TOOL}-${VERSION}.linux-${ARCH}"
BASE="https://github.com/prometheus/${TOOL}/releases/download/v${VERSION}"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cd "${TMP}"

wget -q -O "${NAME}.tar.gz" "${BASE}/${NAME}.tar.gz"
wget -q -O sha256sums.txt "${BASE}/sha256sums.txt"
grep -F " ${NAME}.tar.gz" sha256sums.txt | sha256sum -c -
tar xzf "${NAME}.tar.gz"

for bin in "${NAME}"/*; do
    if [ -f "${bin}" ] && [ -x "${bin}" ]; then
        install -m 0755 "${bin}" "/usr/local/bin/$(basename "${bin}")"
    fi
done
