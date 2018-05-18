#https://hub.docker.com/_/debian/
FROM debian:testing
MAINTAINER Sam Gleske <sam.mxracer@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

ADD 90gimp-apt /etc/apt/apt.conf.d/90gimp

# common utilities + Java 1.8 is required by Jenkins
RUN chown root. /etc/apt/apt.conf.d/90gimp && \
chmod 644 /etc/apt/apt.conf.d/90gimp && \
apt-get update && \
apt-get install ca-certificates ca-certificates-java curl dnsutils git netcat sudo unzip zip openjdk-8-jre && \
apt-get clean

#add Jenkins user
RUN adduser --quiet jenkins && \
su - jenkins -c "mkdir -p /home/jenkins/usr"

# container init
RUN curl -Lo /bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 && \
bash -c 'sha256sum -c <<< "057ecd4ac1d3c3be31f82fc0848bf77b1326a975b4f8423fe31607205a0fe945  /bin/dumb-init"' && \
chmod 755 /bin/dumb-init

# additional environment variables
ENV PREFIX=/home/jenkins/usr
ENV PATH="$PREFIX/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV PKG_CONFIG_PATH="$PREFIX/share/pkgconfig:$PREFIX/lib/pkgconfig"
ENV LD_LIBRARY_PATH="$PREFIX/lib"

#install BABL dependencies
RUN apt-get update && \
apt-get install autoconf automake build-essential git git libtool pkg-config w3m librsvg2-bin && \
apt-get clean

#install GEGL core dependencies
RUN apt-get install autopoint libgtk2.0-dev libglib2.0-dev libjson-glib-dev libjpeg-dev
#install GEGL add-on dependencies
RUN apt-get install asciidoc enscript ruby liblua5.1-0-dev librsvg2-dev libopenexr-dev libsdl-dev libraw-dev libexiv2-dev libgexiv2-dev libv4l-dev libspiro-dev libtiff-dev libwebp-dev

#hacks to allow Jenkins to become root user for Docker image development
#should only be uncommented for development and not be committed
#RUN echo '%sudo ALL=NOPASSWD: ALL' > /etc/sudoers.d/90gimp && usermod -a -G sudo jenkins


# default runtime environment
ENTRYPOINT ["/bin/dumb-init", "--"]
USER 'jenkins'
WORKDIR /home/jenkins
