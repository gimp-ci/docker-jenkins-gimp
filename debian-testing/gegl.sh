#!/bin/bash
#Created by Sam Gleske
#Ubuntu 16.04.4 LTS
#Linux 4.13.0-41-generic x86_64
#GNU bash, version 4.3.48(1)-release (x86_64-pc-linux-gnu)

set -xeo pipefail

initial_workspace="$PWD"

# dependencies
pushd "$PREFIX"
tar -xzf /data/babl-internal.tar.gz
popd

# build
PRODUCT=gegl
REPOSITORY=https://gitlab.gnome.org/GNOME/"${PRODUCT}"
GIT_ARGS=()
if [ -d /export/"${PRODUCT}".git ]; then
    GIT_ARGS=(--reference /export/"${PRODUCT}".git)
fi
[ -d "${PRODUCT}" ] || git clone "${GIT_ARGS[@]}" "${REPOSITORY}"
cd "${PRODUCT}"/
[ -z "${GEGL_BRANCH}" ] || git checkout "${GEGL_BRANCH}"
#build and install (runs by default)
if [ -z "${SKIP_MAKE_BUILD:-}" ]; then
    NOCONFIGURE=1 ./autogen.sh
    ./configure --prefix="$PREFIX"
    make "-j$(nproc)" install
fi
#run tests (runs by default)
[ -n "${SKIP_MAKE_CHECK:-}" ] || make "-j$(nproc)" check
#run distcheck (disabled by default)
[ -z "${INCLUDE_DISTCHECK:-}" ] || make distcheck

# package binaries for use in GIMP build
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz lib/*"${PRODUCT}"* lib/pkgconfig/"${PRODUCT}"* include/"${PRODUCT}"* bin share
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/

cd "${initial_workspace}"
