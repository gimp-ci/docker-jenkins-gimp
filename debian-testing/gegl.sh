PRODUCT=gegl
git clone --reference /export/"${PRODUCT}".git git://git.gnome.org/"${PRODUCT}"
cd "${PRODUCT}"/
./autogen.sh
./configure --prefix="$PREFIX"
