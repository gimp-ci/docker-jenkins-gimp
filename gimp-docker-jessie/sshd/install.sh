#!/bin/bash
set -e
source /build/buildconfig
echo "Configuring SSH." 1>&2
set -x

#apt-get install openssh-server
sed -i 's#\(session\s\+\)required\(\s\+pam_loginuid.so\)#\1optional\2#g' /etc/pam.d/sshd
