#!/bin/bash
#Created by Sam Gleske
#Ubuntu 16.04.4 LTS
#Linux 4.13.0-41-generic x86_64
#GNU bash, version 4.3.48(1)-release (x86_64-pc-linux-gnu)

set -xeo pipefail

initial_workspace="$PWD"

# dependencies
pushd "$PREFIX"
for x in /data/{babl,gegl,libmypaint}-internal.tar.gz; do
    tar -xzf "${x}"
done
popd

# build
PRODUCT=mypaint-brushes
REPOSITORY=https://github.com/Jehan/mypaint-brushes.git
GIT_ARGS=()
if [ -d /export/"${PRODUCT}".git ]; then
    GIT_ARGS=(--reference /export/"${PRODUCT}".git)
fi
[ -d "${PRODUCT}" ] || git clone "${GIT_ARGS[@]}" "${REPOSITORY}"
cd "${PRODUCT}"/
if [ -d /export/"${PRODUCT}".git ]; then
    git fetch /export/"${PRODUCT}".git '+refs/heads/v1.3.x:refs/remotes/origin/v1.3.x'
    git checkout 'v1.3.x'
fi
./autogen.sh
./configure --prefix="$PREFIX"
make "-j$(nproc)" install

# package binaries for use in GIMP build
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz share/pkgconfig/"${PRODUCT}"* share/mypaint-data
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/

cd "${initial_workspace}"
