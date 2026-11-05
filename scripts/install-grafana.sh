#!/usr/bin/env sh
# Install grafana
# usage: ./install-grafana.sh VERSION BUILD ARCH; run with sudo/as root

set -eu

usage="usage: ./install-grafana.sh VERSION BUILD ARCH"
VERSION=${1:?${usage}}
BUILD=${2:?${usage}}
ARCH=${3:?${usage}}
NAME="grafana_${VERSION}_${BUILD}_linux_${ARCH}.deb"
URL="https://dl.grafana.com/grafana/release/${VERSION}/${NAME}"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cd "${TMP}"

apt-get update
apt-get install -y adduser ca-certificates libfontconfig1 musl wget

wget -q -O "${NAME}" "${URL}"
wget -q -O "${NAME}.sha256" "${URL}.sha256"
printf '%s  %s\n' "$(cat "${NAME}.sha256")" "${NAME}" | sha256sum -c -
dpkg -i "${NAME}"
