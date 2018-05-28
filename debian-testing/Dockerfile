#https://hub.docker.com/_/debian/
FROM debian:testing
MAINTAINER Sam Gleske <sam.mxracer@gmail.com>

# environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PREFIX=/home/jenkins/usr
ENV PATH="$PREFIX/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV PKG_CONFIG_PATH="$PREFIX/share/pkgconfig:$PREFIX/lib/pkgconfig"
ENV LD_LIBRARY_PATH="$PREFIX/lib"
ENV ACLOCAL_FLAGS="-I $PREFIX/share/aclocal"

ADD 90gimp-apt /etc/apt/apt.conf.d/90gimp

# common utilities + Java 1.8 is required by Jenkins
RUN chown root. /etc/apt/apt.conf.d/90gimp && \
chmod 644 /etc/apt/apt.conf.d/90gimp && \
apt-get update && \
apt-get install ca-certificates ca-certificates-java curl dnsutils git netcat sudo unzip zip openjdk-8-jre && \
apt-get clean

# install BABL dependencies
RUN apt-get update && \
apt-get install autoconf automake build-essential git git libtool pkg-config w3m librsvg2-bin && \
apt-get clean

# install GEGL core dependencies
RUN apt-get update && \
apt-get install autopoint libgtk2.0-dev libglib2.0-dev libjson-glib-dev libjpeg-dev && \
# install GEGL add-on dependencies
apt-get install asciidoc enscript ruby liblua5.1-0-dev librsvg2-dev libopenexr-dev libsdl-dev libraw-dev libexiv2-dev libgexiv2-dev libv4l-dev libspiro-dev libtiff-dev libwebp-dev && \
apt-get clean

# install libmypaint dependencies
RUN apt-get update && \
apt-get install intltool libjson-c-dev && \
apt-get clean

# mypaint-brushes does not require additional dependencies

# install GIMP core dependencies
RUN apt-get update && \
apt-get install gtk-doc-tools xsltproc libbz2-dev libpoppler-glib-dev python-cairo-dev python-dev python-gtk2-dev poppler-data && \
# install GIMP add-on dependencies
apt-get install libheif-dev libwmf-dev libopenjp2-7-dev libaa1-dev iso-codes libgs-dev libwebkitgtk-dev libmng-dev libxpm-dev && \
# test and GUI dependencies
apt-get install xvfb appstream-util desktop-file-utils gtk2-engines-pixbuf xauth libcanberra-gtk-module dbus-x11 && \
apt-get clean

# install GIMP GTK3 dependencies
RUN apt-get update && \
apt-get install libgtk-3-dev libwebkitgtk-3.0-dev libcanberra-gtk3-module at-spi2-core && \
apt-get clean

#
# Create a user and an init for running the build and handling child processes
#

# add Jenkins user
RUN adduser --quiet jenkins && \
su - jenkins -c "mkdir -p \"$PREFIX\"/share/aclocal" && \
mkdir -p /data && \
chown jenkins: /data

# container init
RUN curl -Lo /bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 && \
bash -c 'sha256sum -c <<< "057ecd4ac1d3c3be31f82fc0848bf77b1326a975b4f8423fe31607205a0fe945  /bin/dumb-init"' && \
chmod 755 /bin/dumb-init

# hack to allow jenkins user to become root user for Docker image development
# should only be uncommented for development and not be committed
#RUN echo '%sudo ALL=NOPASSWD: ALL' > /etc/sudoers.d/90gimp && usermod -a -G sudo jenkins && apt-get install vim

# default runtime environment
ENTRYPOINT ["/bin/dumb-init", "--"]
USER 'jenkins'
WORKDIR /home/jenkins
