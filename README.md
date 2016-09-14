# GIMP docker clients

These are the docker build files to create [gimp project][gimp] docker clients
as Jenkins build slaves.  The containers will be used at
[build.gimp.org][gimp-build].

The gimp-unstable docker container comes out of the box with all of the required
prerequisites to build BABL, GEGL, libmypaint, and GIMP.

### About the Images

`gimp-unstable` - Uses [dumb-init][dumb-init] as the entrypoint.  Uses [Debian
Testing docker images][docker-debian] as its base.  This can fully build GIMP
inside of the container.

### Prerequisite requirements

System specs.

* Recommended CPUs: 2 or more cores (tested with 8 CPUs).
* Recommended RAM: 4GB or more (tested with 32GB RAM).
* Recommended free disk: 10GB or more (tested with 220GB disk space).

Required Software:

* Linux Kernel (tested with `Linux 4.4.0-36-generic x86_64`)
* [Docker][docker] (tested with `version 1.11.2, build b9f10c9`)

# Build Docker image

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

Build [BABL][babl] ([GitHub mirror][gh-babl]).

    git clone git://git.gnome.org/babl
    cd babl
    ./autogen.sh
    make -j${THREADS} && make install

Build [GEGL][gegl] ([GitHub mirror][gh-gegl]).

    cd /build
    git clone git://git.gnome.org/gegl
    cd gegl
    ./autogen.sh
    make -j${THREADS} && make install

Build [libmypaint][libmypaint].

    cd /build
    git clone https://github.com/mypaint/libmypaint.git
    cd libmypaint
    ./autogen.sh
    ./configure --enable-gegl
    make -j${THREADS} && make install

Build [GIMP][gimp] ([GitHub mirror][gh-gimp]).

```bash
cd /build
git clone git://git.gnome.org/gimp
cd gimp
./autogen.sh --enable-gtk-doc --enable-binreloc --enable-vector-icons
make -j${THREADS} && make install
#optionally check distribution (mostly used by CI to determine the
#distributed source is good)
VERBOSE=1 make distcheck
```

See [other documentation](docs/) for additional notes.

[babl]: http://gegl.org/babl/
[docker-debian]: https://hub.docker.com/_/debian/
[docker]: https://www.docker.com/
[dumb-init]: https://github.com/Yelp/dumb-init
[gegl]: http://www.gegl.org/
[gh-babl]: https://github.com/GNOME/babl
[gh-gegl]: https://github.com/GNOME/gegl
[gh-gimp]: https://github.com/GNOME/gimp
[gimp-build]: https://build.gimp.org/
[gimp]: http://www.gimp.org/
[libmypaint]: https://github.com/mypaint/libmypaint
