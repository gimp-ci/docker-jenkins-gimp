#!/bin/bash
export PS4='$ '
echo "Setting up sudoers." 1>&2
set -x
apt-get install sudo
cp /build/sudoers/90gimp /etc/sudoers.d/90gimp
chown root. /etc/sudoers.d/90gimp
chmod 0440 /etc/sudoers.d/90gimp
