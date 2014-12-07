#!/bin/bash
set -e
source /build/shared/buildconfig
set -x

## Often used tools.
$minimal_apt_get_install curl less nano vim psmisc

## This tool runs a command as another user and sets $HOME.
cp /build/shared/bin/setuser /sbin/setuser
