#!/bin/bash
export PS4='$ '
export DEBIAN_FRONTEND=noninteractive

if [ ! "$USER" = 'root' ]; then
  echo 'Not running as root.' >&2
  exit 1
fi

#auto-yes for apt-get commands
if [ ! -f /etc/apt/apt.conf.d/90gimp ]; then
cat > /etc/apt/apt.conf.d/90gimp <<'EOF'
//http://superuser.com/questions/164553/automatically-answer-yes-when-using-apt-get-install
//force yes to all apt-get operations
APT::Get::Assume-Yes "true";
APT::Get::force-yes "true";

//http://linux.koolsolutions.com/2009/01/07/howto-tell-apt-get-not-to-install-recommends-packages-in-debian-linux/
// Recommends are as of now still abused in many packages
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF
chown root. /etc/apt/apt.conf.d/90gimp
chmod 644 /etc/apt/apt.conf.d/90gimp
fi

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl
## runit package fails to install because /etc/inittab is missing.
touch /etc/inittab

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot

apt-get install apt-transport-https ca-certificates software-properties-common


## Install the SSH server.
apt-get install openssh-server
mkdir -p /var/run/sshd
mkdir -p /etc/service/sshd
cp config/sshd_config /etc/ssh/sshd_config

## Install default SSH key for root and app.
mkdir -p /root/.ssh
chmod 700 /root/.ssh
chown root. /root/.ssh
cp insecure_key.pub /etc/insecure_key.pub
cp insecure_key /etc/insecure_key
chmod 644 /etc/insecure_key*
chown root. /etc/insecure_key*
cp bin/enable_insecure_key /usr/sbin/

#Install utilities
apt-get install curl less nano vim psmisc strace

#Install init
curl -Lo /sbin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64
chown root. /sbin/dumb-init
chmod 755 /sbin/dumb-init

#clean up
apt-get clean
rm -rf /build
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*
rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup
rm -f /etc/ssh/ssh_host_*
