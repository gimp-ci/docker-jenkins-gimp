# GIMP Development Environment

This is the development environment used by [build.gimp.org][gimp-build] to
build and test [GIMP][gimp] from the latest development branches of
[BABL][babl], [GEGL][gegl], and [GIMP][gimp].

### System Requirements

Recommended system specifications:

* Recommended CPUs: 2 or more cores (tested with 4 CPUs).
* Recommended RAM: 4GB or more (tested with 32GB RAM).
* Recommended free disk: 2GB or more (tested with 231GB disk).

Required Software:

* Linux Kernel (tested with `4.13.0-41-generic x86_64 x86_64`)
* [Docker][docker] (tested with `Docker version 1.13.1, build 092cba3`)

# Getting started

Running `make` without arguments will display a helpful getting started message.

```
GIMP Development Environment
============================

Welcome to developing GIMP within Docker!  Here are some helpful make commands
which simplify using Docker to develop GIMP.

Start the GUI of the latest development version.

    make build-gimp
    make gimp-gui

Start an interactive terminal which also supports starting the GUI.

    make interactive

Other supported make targets:

    make clean-all
        Deletes all volumes and Docker images created by this repository.
        If developing the container it is also recommended to run
        "docker image prune"

    make end-to-end
        Builds everything from scratch and runs a test build of GIMP and
        its dependencies.  This is meant for the CI environment to run a
        full container build pulling in the latest Debian testing packages.

    make promote
        Promotes the latest unstable image to stable status and tags it.
        This assumes the unstable image passed end to end testing.  This is
        meant for the CI environment to auto-promote its own images.

    make dockerhub-publish
        Publishes the latest stable images to the official GIMP Docker Hub
        site.  Assumes "make promotion" and "docker login" have been run.
        This target is meant to be run by the CI environment.
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
[docker]: https://www.docker.com/
[gegl]: http://gegl.org/
[gimp-build]: https://build.gimp.org/
[gimp]: http://www.gimp.org/
[libmypaint]: https://github.com/mypaint/libmypaint
[mypaint-brushes]: https://github.com/Jehan/mypaint-brushes/tree/v1.3.x
