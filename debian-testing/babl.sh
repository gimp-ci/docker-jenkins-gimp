set -xeo pipefail

initial_workspace="$PWD"

# build
PRODUCT=babl
git clone --reference /export/"${PRODUCT}".git git://git.gnome.org/"${PRODUCT}"
cd "${PRODUCT}"/
./autogen.sh
./configure --prefix="$PREFIX"
make "-j$(nproc)" install

# package binaries for use in GEGL and GIMP build
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz lib/*"${PRODUCT}"* lib/pkgconfig/"${PRODUCT}"* include/"${PRODUCT}"*
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/

cd "${initial_workspace}"
