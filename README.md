# GIMP docker clients

These are the docker build files to create [gimp project][gimp] docker clients
as Jenkins build slaves.  The containers will be used at
[build.gimp.org][gimp-build].

The gimp-unstable docker container comes out of the box with all of the required
prerequisites to build BABL, GEGL, libmypaint, and GIMP.

# About the Images

`gimp-unstable` - Uses [dumb-init][dumb-init] as the entrypoint.  Uses [Debian
Testing docker images][docker-debian] as its base.  This can fully build GIMP
inside of the container.

# Build instructions using make

To build the docker image.

```
make
```

This will execute `make build` which will build the latest version of the
gimp-unstable docker image.

# Building GIMP inside docker

Run docker to enter the container.

    docker run -it --rm samrocketman/gimp-unstable:latest /bin/bash

Export environment variables.

    THREADS=$(($(nproc)+1))
    export LD_LIBRARY_PATH=/usr/lib:/usr/lib/x86_64-linux-gnu:/usr/local/lib
    export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/local/lib/pkgconfig

Build [BABL][babl].

    git clone git://git.gnome.org/babl
    ./autogen.sh
    make -j${THREADS} && make install

Build [GEGL][gegl].

    git clone git://git.gnome.org/gegl
    ./autogen.sh
    make -j${THREADS} && make install

Build [libmypaint][libmypaint].

    git clone https://github.com/mypaint/libmypaint.git
    ./autogen.sh
    ./configure --enable-gegl
    make -j${THREADS} && make install

Build [GIMP][gimp].

    git clone git://git.gnome.org/gimp
    ./autogen.sh --enable-gtk-doc --enable-binreloc --enable-vector-icons
    make -j${THREADS} && make install

[babl]: http://gegl.org/babl/
[docker-debian]: https://hub.docker.com/_/debian/
[dumb-init]: https://github.com/Yelp/dumb-init
[gegl]: http://www.gegl.org/
[gimp-build]: https://build.gimp.org/
[gimp]: http://www.gimp.org/
[libmypaint]: https://github.com/mypaint/libmypaint
