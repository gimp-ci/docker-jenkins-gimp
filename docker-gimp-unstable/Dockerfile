#https://hub.docker.com/_/debian/
FROM debian:testing
MAINTAINER Sam Gleske <sam.mxracer@gmail.com>

#Copy scripts into docker environment
ENV HOME /root
ENV USER root
RUN mkdir /build
ADD . /build
WORKDIR /build

RUN ./setup-agent.sh

# Standard SSH port
EXPOSE 22

ENTRYPOINT ["/sbin/dumb-init", "--"]

#default command
CMD ["/root/sshd"]
