# Jervis docker clients

These are the docker build files to create [gimp project][gimp] docker clients
as Jenkins build slaves.

Docker files were written with a combination of
[evarga/jenkins-slave][jenkins-slave],
[pokle/centos-baseimage][centos-baseimage], [phusion/baseimage][phusion], and
[samrocketman/jervis-docker][jervis-docker].

The gimp-docker container comes out of the box with all of the required
prerequisites to build GIMP, BABL, and GEGL.  This same image is used by the
[GIMP Jenkins instance][gimp-jenkins] to build the projects inside of a
container environment.

# Ubuntu gimp-docker

To build the `gimp-docker` image execute the following commands.

```
docker build -t gimp-docker .
```

To view the image interactively it is recommeneded to connect to the container
over SSH.  First you must get the private key.

```
curl -o insecure_key -fSL https://github.com/phusion/baseimage-docker/raw/master/image/insecure_key
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
[gimp]: http://www.gimp.org/
[jenkins-slave]: https://github.com/evarga/docker-images/blob/master/jenkins-slave/Dockerfile
[jervis-docker]: https://github.com/samrocketman/jervis-docker
[jervis]: https://github.com/samrocketman/jervis
[phusion]: https://github.com/phusion/baseimage-docker
