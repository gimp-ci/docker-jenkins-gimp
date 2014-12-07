#!/bin/bash
set -e
source /build/buildconfig
echo "Installing GEGL prerequisite packages." 1>&2
set -x

DEPS=(
w3m
)

apt-get install ${DEPS[*]}
