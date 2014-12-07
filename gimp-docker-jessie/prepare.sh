#!/bin/bash
set -e
source /build/buildconfig
set -x

## update the package cache
apt-get update
