#!/bin/bash
#Created by Sam Gleske
#Ubuntu 16.04.4 LTS
#Linux 4.13.0-41-generic x86_64
#GNU bash, version 4.3.48(1)-release (x86_64-pc-linux-gnu)

set -xeo pipefail

initial_workspace="$PWD"

# dependencies
pushd "$PREFIX"
for x in /data/{babl,gegl,libmypaint,mypaint-brushes}-internal.tar.gz; do
    tar -xzf "${x}"
done
popd

# build
PRODUCT=gimp
REPOSITORY=https://gitlab.gnome.org/GNOME/"${PRODUCT}"
GIT_ARGS=()
if [ -d /export/"${PRODUCT}".git ]; then
    GIT_ARGS=(--reference /export/"${PRODUCT}".git)
fi
[ -d "${PRODUCT}" ] || git clone "${GIT_ARGS[@]}" "${REPOSITORY}"
cd "${PRODUCT}"/
[ -z "${GIMP_BRANCH}" ] || git checkout "${GIMP_BRANCH}"
./autogen.sh --prefix="$PREFIX" --enable-gtk-doc
make "-j$(nproc)" install
[ -n "${SKIP_MAKE_CHECK:-}" ] || make check

## package binaries for use in GIMP build
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz *
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/

cd "${initial_workspace}"
