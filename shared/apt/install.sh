#!/bin/bash
export PS4='$ '
echo "Setting up APT"
set -x
cp /build/apt/90gimp /etc/apt/apt.conf.d/90gimp
chown root. /etc/apt/apt.conf.d/90gimp
chmod 644 /etc/apt/apt.conf.d/90gimp
