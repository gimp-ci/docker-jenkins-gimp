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

# Prepare gimp-bin docker volume

This is meant only for non-Jenkins environments where a developer can share
binaries for BABL and GEGL as required dependencies for GIMP builds.

    docker volume create gimp-bin
    docker run -v gimp-bin:/data -u root --rm gimp:latest /bin/bash -c 'chown jenkins: /data'

# Build BABL

Build BABL in a non-interactive Docker environment.

    docker run -iv gimp-data:/export:ro -v gimp-bin:/data:rw --rm gimp:latest /bin/bash < babl.sh

# Build GEGL

Build GEGL in a non-interactive Docker environment.

    docker run -iv gimp-data:/export:ro -v gimp-bin:/data:rw --rm gimp:latest /bin/bash < gegl.sh

# Build libmypaint 1.3.0

GIMP specifically requires version libmypaint 1.3.0.  Build libmypaint in a
non-interactive Docker environment.

    docker run -iv gimp-data:/export:ro -v gimp-bin:/data:rw --rm gimp:latest /bin/bash < libmypaint.sh

# Build mypaint-brushes 1.0

GIMP specifically requires version mypaint-brushes 1.0.  Build mypaint-brushes
in a non-interactive Docker environment.

    docker run -iv gimp-data:/export:ro -v gimp-bin:/data:rw --rm gimp:latest /bin/bash < mypaint-brushes.sh

# Interactive Docker environment

To start an interactive docker environment execute the following command.

    docker run -v gimp-data:/export:ro -v gimp-bin:/data -it --rm gimp:latest /bin/bash

While in the interactive environment it is good to remember the following tips:

- `/export` path contains git repositories for babl, gegl, and gimp which can be
  used for reference cloning via `git clone --reference ...`.
- `/data` path is the only write-able path which will persist across restarting
  the interactive development environment.  This is useful for saving and
  re-using binaries and dependencies.
- Refer to [`babl.sh`](babl.sh) and [`gegl.sh`](gegl.sh) for how the interactive
  environment could be used.
