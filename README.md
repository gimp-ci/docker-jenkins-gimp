# GIMP development environment

This is the development environment used by [build.gimp.org][gimp-build] to
build and test [GIMP][gimp] from the latest development branches of BABL, GEGL,
and GIMP.

### System Requirements

Recommended system specifications:

* Recommended CPUs: 2 or more cores (tested with 4 CPUs).
* Recommended RAM: 4GB or more (tested with 32GB RAM).
* Recommended free disk: 2GB or more (tested with 231GB disk).

Required Software:

* Linux Kernel (tested with `4.13.0-41-generic x86_64 x86_64`)
* [Docker][docker] (tested with `Docker version 1.13.1, build 092cba3`)

# Run end to end testing

End to end testing will start from the latest base [`debian:testing`][debian]
docker image and builds from scratch the GIMP development environment (tagged as
docker image `gimp:unstable`).  Once the development environment is available
this will immediately run through building the latest development versions of
[BABL][babl], [GEGL][gegl], [libmypaint][libmypaint],
[mypaint-brushes][mypaint-brushes], and GIMP.

    make end-to-end

# Manually GIMP inside Docker

Refer to [detailed instructions](debian-testing/README.md) on building GIMP
within the dockerized development environment.

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
