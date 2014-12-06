FROM debian:jessie
MAINTAINER Sam Gleske <sam.mxracer@gmail.com>

ENV HOME /root
RUN mkdir -p /build/shared
ADD . /build
ADD ../shared /build/shared

RUN /build/prepare.sh && \
	/build/system_services.sh && \
	/build/utilities.sh && \
	/build/cleanup.sh

CMD ["/sbin/my_init"]
