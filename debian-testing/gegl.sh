set -xeo pipefail

initial_workspace="$PWD"

# dependencies
pushd "$PREFIX"
tar -xzf /data/babl-internal.tar.gz
popd

# build
PRODUCT=gegl
git clone --reference /export/"${PRODUCT}".git git://git.gnome.org/"${PRODUCT}"
cd "${PRODUCT}"/
./autogen.sh
./configure --prefix="$PREFIX"
make "-j$(nproc)" install

# package binaries for use in GIMP build
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz lib/*"${PRODUCT}"* lib/pkgconfig/"${PRODUCT}"* include/"${PRODUCT}"* bin share
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/

cd "${initial_workspace}"
