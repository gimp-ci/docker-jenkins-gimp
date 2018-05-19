set -xeo pipefail

# dependencies
pushd "$PREFIX"
for x in /data/{babl,gegl}-internal.tar.gz; do
    tar -xzf "${x}"
done
popd

# build
PRODUCT=libmypaint
git clone --reference /export/"${PRODUCT}".git https://github.com/mypaint/libmypaint.git
cd "${PRODUCT}"/
git fetch /export/"${PRODUCT}".git '+refs/tags/v1.3.0:refs/tags/v1.3.0'
git checkout 'v1.3.0'
./autogen.sh
./configure --prefix="$PREFIX"
make "-j$(nproc)" install
## package binaries for use in GIMP build
pushd "$PREFIX"
find share -type f -name libmypaint.mo -print0 | xargs -0 -- tar -czvf ~1/"${PRODUCT}"-internal.tar.gz lib/*"${PRODUCT}"* lib/pkgconfig/"${PRODUCT}"* include/"${PRODUCT}"*
popd
cp -f "${PRODUCT}"-internal.tar.gz /data/
