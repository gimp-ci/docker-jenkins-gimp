#!/bin/bash
#Created by Sam Gleske
#Ubuntu 16.04.4 LTS
#Linux 4.13.0-41-generic x86_64
#GNU bash, version 4.3.48(1)-release (x86_64-pc-linux-gnu)

set -xeo pipefail

initial_workspace="$PWD"

# dependencies
pushd "$PREFIX"
for x in /data/{babl,gegl}-internal.tar.gz; do
    tar -xzf "${x}"
done
popd

# build
PRODUCT=libmypaint
REPOSITORY=https://github.com/mypaint/libmypaint.git
GIT_ARGS=()
if [ -d /export/"${PRODUCT}".git ]; then
    GIT_ARGS=(--reference /export/"${PRODUCT}".git)
fi
[ -d "${PRODUCT}" ] || git clone "${GIT_ARGS[@]}" "${REPOSITORY}"
cd "${PRODUCT}"/
if [ -d /export/"${PRODUCT}".git ]; then
    git fetch /export/"${PRODUCT}".git '+refs/tags/v1.3.0:refs/tags/v1.3.0'
    git checkout 'v1.3.0'
fi
./autogen.sh
./configure --prefix="$PREFIX"
make "-j$(nproc)" install

# package binaries for use in GIMP build
pushd "$PREFIX"
find share -type f -name libmypaint.mo -print0 | xargs -0 -- tar -czvf ~1/"${PRODUCT}"-internal.tar.gz lib/*"${PRODUCT}"* lib/pkgconfig/"${PRODUCT}"* include/"${PRODUCT}"*
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/

cd "${initial_workspace}"
