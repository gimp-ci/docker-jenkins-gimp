FROM debian:jessie
MAINTAINER Sam Gleske <sam.mxracer@gmail.com>

#Copy scripts into docker environment
ENV HOME /root
RUN mkdir /build
ADD . /build
WORKDIR /build

#apt should always use -y --no-install-recommends
RUN setup-agent.sh

# Standard SSH port
EXPOSE 22

ENTRYPOINT ["/sbin/dumb-init", "--"]

#default command
CMD ["/usr/sbin/sshd", "-D"]
