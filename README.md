# GIMP Development Environment

This is the development environment used by [build.gimp.org][gimp-build] to
build and test [GIMP][gimp] from the latest development branches of
[BABL][babl], [GEGL][gegl], and [GIMP][gimp].

### System Requirements

Recommended system specifications:

* Recommended CPUs: 2 or more cores (tested with 4 CPUs).
* Recommended RAM: 4GB or more (tested with 32GB RAM).
* Recommended free disk: 2GB or more (tested with 231GB disk).

Recommended Software:

* Linux Kernel (tested with `4.13.0-41-generic x86_64 x86_64`)
* [Docker][docker] (tested with `Docker version 1.13.1, build 092cba3`)

If using Mac OS X:

* [Docker for Mac][docker4m]
* [XQuartz][xquartz]

# Getting started

Running `make` without arguments will display a helpful getting started message.

```
GIMP Development Environment
============================

Welcome to developing GIMP within Docker!  Here are some helpful make commands
which simplify using Docker to develop GIMP.

Start the GUI of the latest development version (to run tests remove the
`SKIP_TESTS` argument).

    make SKIP_TESTS=1 build-gimp
    make gimp-gui

Start an interactive terminal which also supports starting the GUI.

    make interactive

Other supported make targets:

    make clean
        Will only delete the volume used to house internal binary artifacts
        for building.

    make clean-all
        Deletes all volumes and Docker images created by this repository.
        If developing the container it is also recommended to run
        "docker image prune"

    make end-to-end
        Builds everything from scratch and runs a test build of GIMP and
		its dependencies.  Covers GIMP versions 2.8, 2.10, and master.
        This is meant for the CI environment to run a full container build
        pulling in the latest Debian testing packages.

    make promote
        Promotes the latest unstable image to stable status and tags it.
        This assumes the unstable image passed end to end testing.  This is
        meant for the CI environment to auto-promote its own images.

    make dockerhub-publish
        Publishes the latest stable images to the official GIMP Docker Hub
        site.  Assumes "make promotion" and "docker login" have been run.
        This target is meant to be run by the CI environment.

Configurable environment variables:

    BIN_SUFFIX
        Configures an additional suffix for the gimp-bin docker volume.
        The volume is used to hold intermediate binary artifacts.  Useful
        to customize working on multiple versions of GIMP simultaneously.

    GEGL_BRANCH
        Customize the git branch to build GEGL.  Useful for building
        alternate versions of GIMP.

    GIMP_BRANCH
        Customize the git branch to build GIMP.  Useful for building
        alternate versions of GIMP.
```

# Building alternate GIMP versions

The GIMP Development Environment by default builds the latest development branch
(GIMP branch `master`).  However, other branches of GIMP and GEGL can be built
as well.  Customizable environment variables.

| Variable      | Description                                                 |
| ------------- | ----------------------------------------------------------- |
| `BIN_SUFFIX`  | Customizes the intermediate binary artifact docker volume.  |
| `GEGL_BRANCH` | Customizes the `git` branch to build for GEGL.              |
| `GIMP_BRANCH` | Customizes the `git` branch to build for GIMP.              |

The binary artifact volume (can be seen with `docker volume ls` command) is
named `gimp-bin` by default.  This volume is used to share intermediate binary
artifacts in order to build GIMP and all of its dependencies across multiple
containers as well as launching the GIMP GUI.  This should definitely be
customized if planning to build and launch multiple versions of GIMP
simultaneously.

### Build GIMP 2.8

To build and run the latest GIMP 2.8 run the following commands.

```bash
export BIN_SUFFIX='-2.8'
export GEGL_BRANCH='gegl-0-2'
export GIMP_BRANCH='gimp-2-8'
export SKIP_TESTS=1
make build-gimp
make gimp-gui
```

### Build GIMP 2.10

To build and run the latest GIMP 2.10 run the following commands.

```bash
export BIN_SUFFIX='-2.10'
export GIMP_BRANCH='gimp-2-10'
export SKIP_TESTS=1
make build-gimp
make gimp-gui
```

### Build GIMP master

No environment changes are required to build GIMP from `master`.  Simply run:

```
export SKIP_TESTS=1
make build-gimp
make gimp-gui
```

# Run end to end testing

End to end testing will start from the latest base [`debian:testing`][debian]
docker image and builds from scratch the GIMP development environment (tagged as
docker image `gimp:unstable`).  Once the development environment is available
this will immediately run through building the latest development versions of
[BABL][babl], [GEGL][gegl], [libmypaint][libmypaint],
[mypaint-brushes][mypaint-brushes], and [GIMP][gimp].

    make end-to-end

# Manually build GIMP inside Docker

Refer to [detailed instructions](debian-testing/README.md) on building GIMP
within the dockerized development environment from scratch.

# Thanks

- [The GIMP Team on IRC](https://www.gimp.org/irc.html) for patience and help.

[babl]: http://gegl.org/babl/
[debian]: https://hub.docker.com/r/library/debian/
[docker4m]: https://www.docker.com/docker-mac
[docker]: https://www.docker.com/
[gegl]: http://gegl.org/
[gimp-build]: https://build.gimp.org/
[gimp]: http://www.gimp.org/
[libmypaint]: https://github.com/mypaint/libmypaint
[mypaint-brushes]: https://github.com/Jehan/mypaint-brushes/tree/v1.3.x
[xquartz]: https://www.xquartz.org/
