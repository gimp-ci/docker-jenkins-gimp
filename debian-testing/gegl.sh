set -xeo pipefail
if [ -f /data/babl-internal.tar.gz ]; then
    (
    cd "$PREFIX"
    tar -xzf /data/babl-internal.tar.gz
    )
else
    echo 'ERROR: must run BABL build first.' >&2
    exit 1
fi
PRODUCT=gegl
git clone --reference /export/"${PRODUCT}".git git://git.gnome.org/"${PRODUCT}"
cd "${PRODUCT}"/
./autogen.sh
./configure --prefix="$PREFIX"
make "-j$(nproc)" install
# package binaries for use in GIMP build
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz lib/*"${PRODUCT}"* include/"${PRODUCT}"* lib/pkgconfig/"${PRODUCT}"* bin share
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/
