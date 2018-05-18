PRODUCT=babl
git clone --reference /export/"${PRODUCT}".git git://git.gnome.org/"${PRODUCT}"
cd "${PRODUCT}"/
./autogen.sh
./configure --prefix="$PREFIX"
make "-j$(nproc)" install
pushd "$PREFIX"
tar -czvf ~1/"${PRODUCT}"-internal.tar.gz lib/"${PRODUCT}"* include/"${PRODUCT}"* lib/pkgconfig/"${PRODUCT}"*
popd
cp -f babl-internal.tar.gz /data/
