# Build docker container

Build the docker image used for building GIMP and its dependencies.

    docker build -t gimp .

This will create the docker image and tag `gimp:latest`

# Prepare gimp-data docker volume

The `gimp-data` docker volume will be used by other docker containers to speed
up cloning from gnome.  This has two benefits:

- Cloning from GNOME infrastructure occurs more quickly.
- Less strain is placed on GNOME infrastructure by locally caching the majority
  of the git data to be cloned.

Create a `gimp-data` volume which will be used by GIMP for reference cloning.

    docker volume create gimp-data
    docker run -iv gimp-data:/export -u root --rm gimp:latest /bin/bash < update-git-reference.sh

The `docker run` command can also be used to update the git data in the volume.

# Build BABL

Start the development environment

    docker run -v gimp-data:/export:ro -it --rm gimp:latest /bin/bash

Clone the sources but include the reference `gimp-data` volume to speed up
cloning.

    git clone --reference /export/babl.git git://git.gnome.org/babl
    cd babl/

Build BABL.

    ./autogen.sh
    ./configure --prefix="$PREFIX"
    make "-j$(nproc)"

Package BABL binaries for use in a dependent build.

    pushd "$PREFIX"
    tar -czvf ~1/babl-internal.tar.gz lib/babl* include/babl* lib/pkgconfig/babl*
    popd

Collect `babl-internal.tar.gz` as an artifact.
