# GIMP docker clients

These are the docker build files to create [gimp project][gimp] docker clients
as Jenkins build slaves.  The containers are used at
[build.gimp.org][gimp-build].

Docker files were written with a combination of
[evarga/jenkins-slave][jenkins-slave],
[pokle/centos-baseimage][centos-baseimage], [phusion/baseimage][phusion], and
[samrocketman/jervis-docker][jervis-docker].

The gimp-docker container comes out of the box with all of the required
prerequisites to build GIMP, BABL, and GEGL.  This same image is used by the
[GIMP Jenkins instance][gimp-build] to build the projects inside of a
container environment.

# About the Images

`baseimage-jessie` was created using [phusion/baseimage][phusion].  You should
check out that repository to learn more about it in depth.  This is the base
image for Debian Testing (Jessie) from which gimp master is currently being
developed.

# Build instructions using make

To build the baseimage.

```
make build_baseimage_jessie
make tag_baseimage_jessie_latest
```

# Build instructions without make

To build any of the docker images simply execute.

```
docker build -t gimp-docker .
```

To view the image interactively it is recommeneded to connect to the container
over SSH.  First you must get the private key.

```
curl -o insecure_key -fSL https://github.com/samrocketman/gimp-docker/blob/master/baseimage-jessie/insecure_key
chmod 600 insecure_key
```

Then start the container.

```
docker create gimp-docker | xargs docker start | xargs docker inspect -f "{{ .NetworkSettings.IPAddress }}"
```

The value returned from starting the container is the IP address.  Use that IP
to connect over SSH.

```
ssh -i insecure_key jenkins@<ip address>
```

To run a simple bash session in the container.

```
docker run -i -t gimp-docker /bin/bash
```

[centos-baseimage]: https://github.com/pokle/centos-baseimage/blob/master/image/Dockerfile
[gimp-build]: https://build.gimp.org/
[gimp]: http://www.gimp.org/
[jenkins-slave]: https://github.com/evarga/docker-images/blob/master/jenkins-slave/Dockerfile
[jervis-docker]: https://github.com/samrocketman/jervis-docker
[jervis]: https://github.com/samrocketman/jervis
[phusion]: https://github.com/phusion/baseimage-docker
