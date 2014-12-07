FROM samrocketman/baseimage-jessie
MAINTAINER Sam Gleske <sam.mxracer@gmail.com>

#Copy scripts into docker environment
ENV HOME /root
RUN mkdir /build
ADD . /build
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

#prepare the system
RUN /build/prepare.sh

#install sudo with no password for sudo group
RUN /build/sudoers/install.sh

#configure the SSH server
RUN /build/sshd/install.sh

#install GIMP prerequisite packages
#RUN /build/gimp-packages/install.sh

#jenkins user info (depends on sudo)
RUN /build/jenkins/install.sh

#some final clean up
RUN /build/cleanup.sh

# Standard SSH port
EXPOSE 22

#default command
CMD ["/sbin/my_init"]
