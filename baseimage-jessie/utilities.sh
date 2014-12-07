#!/bin/bash
set -e
source /build/share/buildconfig
set -x

## Often used tools.
$minimal_apt_get_install curl less nano vim psmisc

## This tool runs a command as another user and sets $HOME.
cp /build/bin/setuser /sbin/setuser
