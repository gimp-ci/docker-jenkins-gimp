#!/bin/bash -e
#Created by Sam Gleske
#Tue Sep 13 14:08:55 PDT 2016
#Prerequisites for:
#  * BABL - git://git.gnome.org/babl
#  * GEGL - git://git.gnome.org/gegl
#  * libmypaint - https://github.com/mypaint/libmypaint.git
#  * GIMP - git clone git://git.gnome.org/gimp
#Packages are for Debian Testing

BABL_DEPS=(
autoconf
automake
build-essential
git
git
libtool
pkg-config
)

GEGL_DEPS=(
asciidoc
enscript
intltool
libexiv2-dev
libgexiv2-dev
libglib2.0-dev
libjasper-dev
libjpeg-dev
libjson-glib-dev
liblua5.1-0-dev
libopenexr-dev
libpango1.0-dev
libpng-dev
libraw-dev
librsvg2-dev
libsdl-dev
libspiro-dev
libtiff-dev
libv4l-dev
libwebp-dev
ruby
valac
)

LIBMYPAINT_DEPS=(
libgirepository1.0-dev
libjson-c-dev
)

GIMP_DEPS=(
gtk-doc-tools
libaa1-dev
libasound2-dev
libbz2-dev
libgs-dev
libgtk2.0-bin
libgtk2.0-dev
libgudev-1.0-dev
libmng-dev
libpoppler-glib-dev
libsuitesparse-dev
libwebkitgtk-dev
libwmf-dev
libxpm-dev
python-cairo-dev
python-dev
python-gtk2-dev
xauth
xdg-utils
xvfb
)


#install prereqs
apt-get install \
  ${BABL_DEPS[*]} \
  ${GEGL_DEPS[*]} \
  ${LIBMYPAINT_DEPS[*]} \
  ${GIMP_DEPS[*]}
