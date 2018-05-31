# GIMP Development Environment

This is the development environment used by [build.gimp.org][gimp-build] to
build and test [GIMP][gimp] from the latest development branches of
[BABL][babl], [GEGL][gegl], and [GIMP][gimp].

### Table of Contents

* [Getting started](#getting-started)
* [Building alternate GIMP versions](#building-alternate-gimp-versions)
* [Run end to end testing](#run-end-to-end-testing)
* [Troubleshooting builds on build.gimp.org](#troubleshooting-builds-on-buildgimporg)
* [Manually build GIMP inside Docker](#manually-build-gimp-inside-docker)

### System Requirements

Recommended system specifications:

* Recommended CPUs: 2 or more cores (tested with 4 CPUs).
* Recommended RAM: 4GB or more (tested with 32GB RAM).
* Recommended free disk: 2GB or more (tested with 231GB disk).

Recommended Software:

* Linux Kernel (tested with `4.13.0-41-generic x86_64 x86_64`)
* [Docker][docker] (tested with `Docker version 18.03.1-ce, build 9ee9f40`)
* [X Window System][xorg] (a.k.a. X11) (tested with `X11R7.7`)

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

| Variable      | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| `BIN_SUFFIX`  | Customizes the intermediate binary artifact docker volume.   |
| `GEGL_BRANCH` | Customizes the `git` branch to build for GEGL.               |
| `GIMP_BRANCH` | Customizes the `git` branch to build for GIMP.               |

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

```bash
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

# Troubleshooting builds on build.gimp.org

Sometimes it might make sense to troubleshoot and replicate problems from
[build.gimp.org][gimp-build] locally within the docker build environment.  To
that end the following environment variables and make commands are available.

Build scripts located in this repository are available inside of the interactive
environment at `/mnt/debian-testing/`.

The following variables control build scripts.  By default, the build scripts
run a build (via `make install`) and tests (via `make check`).

| Variable            | Description                                            |
| ------------------- | ------------------------------------------------------ |
| `SKIP_TESTS`        | Skips `make check` which tests projects.               |
| `INCLUDE_DISTCHECK` | Runs a `make distcheck` which doesn't run by default.  |

The following variables customize what versions are built.

| Variable      | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| `BABL_BRANCH` | Customizes the `git` branch to build for BABL.               |
| `GEGL_BRANCH` | Customizes the `git` branch to build for GEGL.               |
| `GIMP_BRANCH` | Customizes the `git` branch to build for GIMP.               |

```bash
# create volumes necessary for building GIMP
make volumes

# build only BABL
make build-babl-only

# build only GEGL
make build-gegl-only

# build only GIMP
make build-gimp-only
```

### Resetting a local test environment

Since the `gimp-bin` volume is necessary for saving artifacts from builds, then
to reset the troubleshooting environment this should be deleted and recreated
anew.

```
make clean-bin-volume volumes
```

Now build commands can run without any prior binary artifacts in the `gimp-bin`
docker volume.

### Replicating issues from build.gimp.org artifacts

Sometimes, it is desirable to replicate issues from artifacts created on
[build.gimp.org][gimp-build].  For example, let's utilize the interactive docker
environment to replicate a hypothetical issue on the GIMP `master` branch.

```bash
# reset binary volumes
make clean-bin-volume volumes

# enter the interactive environment
make interactive
```

From within the interactive environment we can troubleshoot a build for GIMP by
pulling down its prerequisite artifacts first.

```bash
# Download dependent artifacts from build.gimp.org
cd /data/
curl -LO https://build.gimp.org/job/babl/job/master/lastSuccessfulBuild/artifact/babl/babl-internal.tar.gz
curl -LO https://build.gimp.org/job/gegl/job/master/lastSuccessfulBuild/artifact/gegl-internal.tar.gz
curl -LO https://build.gimp.org/job/libmypaint/job/v1.3.0/lastSuccessfulBuild/artifact/libmypaint-internal.tar.gz
curl -LO https://build.gimp.org/job/mypaint-brushes/job/v1.3.x/lastSuccessfulBuild/artifact/mypaint-brushes-internal.tar.gz
cd "$HOME"

# Execute a build on the lastest GIMP master branch using the same build scripts
# as build.gimp.org
SKIP_MAKE_CHECK=1 bash /mnt/debian-testing/gimp.sh

# Execute tests
SKIP_MAKE_BUILD=1 bash /mnt/debian-testing/gimp.sh

# Execute a distcheck
SKIP_MAKE_BUILD=1 SKIP_MAKE_CHECK=1 INCLUDE_DISTCHECK=1 bash /mnt/debian-testing/gimp.sh

# When the build finishes gimp GUI can be started from within the interactive
# container.
gimp-2.99
```

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
[xorg]: https://www.x.org/
[xquartz]: https://www.xquartz.org/
