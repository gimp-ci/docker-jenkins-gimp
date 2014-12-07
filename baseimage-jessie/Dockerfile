FROM debian:jessie
MAINTAINER Sam Gleske <sam.mxracer@gmail.com>

#Copy scripts into docker environment
ENV HOME /root
RUN mkdir -p /build/shared
ADD . /build
ADD ../shared /build/shared

#apt should always use -y --no-install-recommends
RUN /build/apt/install.sh

RUN /build/prepare.sh && \
	/build/system_services.sh && \
	/build/utilities.sh && \
	/build/cleanup.sh

# Standard SSH port
EXPOSE 22
#default command
CMD ["/sbin/my_init"]
