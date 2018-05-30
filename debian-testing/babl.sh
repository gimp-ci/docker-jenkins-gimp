#!/bin/bash
#Created by Sam Gleske
#Ubuntu 16.04.4 LTS
#Linux 4.13.0-41-generic x86_64
#GNU bash, version 4.3.48(1)-release (x86_64-pc-linux-gnu)

set -xeo pipefail

initial_workspace="$PWD"

# build
PRODUCT=babl
REPOSITORY=https://gitlab.gnome.org/GNOME/"${PRODUCT}"
GIT_ARGS=()
if [ -d /export/"${PRODUCT}".git ]; then
    GIT_ARGS=(--reference /export/"${PRODUCT}".git)
fi
[ -d "${PRODUCT}" ] || git clone "${GIT_ARGS[@]}" "${REPOSITORY}"
cd "${PRODUCT}"/
[ -z "${BABL_BRANCH}" ] || git checkout "${BABL_BRANCH}"
NOCONFIGURE=1 ./autogen.sh
./configure --prefix="$PREFIX"
make "-j$(nproc)" install
[ -n "${SKIP_MAKE_CHECK:-}" ] || make "-j$(nproc)" check

# package binaries for use in GEGL and GIMP build
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz lib/*"${PRODUCT}"* lib/pkgconfig/"${PRODUCT}"* include/"${PRODUCT}"*
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/

cd "${initial_workspace}"
