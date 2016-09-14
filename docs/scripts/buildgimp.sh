#!/bin/bash
#Sam Gleske
#Tue Sep 13 19:08:37 PDT 2016
#Linux 4.4.0-36-generic x86_64
#git version 2.7.4

THREADS=$(($(nproc)+1))
export LD_LIBRARY_PATH=/usr/lib:/usr/lib/x86_64-linux-gnu:/usr/local/lib
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/local/lib/pkgconfig

BUILD_DIR="${BUILD_DIR:-/build}"
BUILD_DIR="${BUILD_DIR%/}"

cd "${BUILD_DIR}"

#Offload most of the work to github.com and then fetch from GNOME infrastructure

for REMOTE in babl gegl gimp;do
  if [ ! -d "${REMOTE}" ]; then
    (#subshell
    git clone "https://github.com/GNOME/${REMOTE}.git"
    cd "${REMOTE}"
    git remote set-url origin "git://git.gnome.org/${REMOTE}"
    git fetch origin master
    git reset --hard origin/master
    )
  fi
done

git clone https://github.com/mypaint/libmypaint.git

#build babl
(
  cd babl
  ./autogen.sh
  make -j${THREADS} && make install
)

#build gegl
(
  cd gegl
  ./autogen.sh
  make -j${THREADS} && make install
)

#build libmypaint
(
  cd libmypaint
  ./autogen.sh
  ./configure --enable-gegl
  make -j${THREADS} && make install
)

#build gimp
(
  cd gimp
  ./autogen.sh --enable-gtk-doc --enable-binreloc --enable-vector-icons
  make -j${THREADS} && make install
)
