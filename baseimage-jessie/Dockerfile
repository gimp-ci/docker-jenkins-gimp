FROM debian:jessie
MAINTAINER Sam Gleske <sam.mxracer@gmail.com>

#Copy scripts into docker environment
ENV HOME /root
RUN mkdir /build
ADD . /build

#apt should always use -y --no-install-recommends
RUN /build/apt/install.sh

#prepare the system
RUN /build/prepare.sh

#install and configure services
RUN /build/system_services.sh

#install useful utilities
RUN /build/utilities.sh

#final clean up
RUN /build/cleanup.sh

# Standard SSH port
EXPOSE 22

#default command
CMD ["/sbin/my_init"]
