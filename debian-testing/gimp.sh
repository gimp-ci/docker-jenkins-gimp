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
git clone --reference /export/"${PRODUCT}".git git://git.gnome.org/"${PRODUCT}"
cd "${PRODUCT}"/
NOCONFIGURE=1 ./autogen.sh
./configure --prefix="$PREFIX"

make "-j$(nproc)" install
## package binaries for use in GIMP build
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz *
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/

cd "${initial_workspace}"
