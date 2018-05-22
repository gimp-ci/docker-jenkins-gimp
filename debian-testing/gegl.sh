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
rm -rf "${PRODUCT}"/
git clone --reference /export/"${PRODUCT}".git git://git.gnome.org/"${PRODUCT}"
cd "${PRODUCT}"/
[ -z "${GEGL_BRANCH}" ] || git checkout "${GEGL_BRANCH}"
NOCONFIGURE=1 ./autogen.sh
./configure --prefix="$PREFIX"
make "-j$(nproc)" install

# package binaries for use in GIMP build
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz lib/*"${PRODUCT}"* lib/pkgconfig/"${PRODUCT}"* include/"${PRODUCT}"* bin share
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/

cd "${initial_workspace}"
