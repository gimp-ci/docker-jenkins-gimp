#!/bin/bash
#Created by Sam Gleske
#Thu May 17 22:19:34 PDT 2018
#Ubuntu 16.04.4 LTS
#Linux 4.13.0-41-generic x86_64
#GNU bash, version 4.3.48(1)-release (x86_64-pc-linux-gnu)

# DESCRIPTION
#    Creates and updates a data directory which will be used for reference
#    cloning GIMP related projects.
#    Example:
#        git clone --reference /export/gimp.git git://git.gnome.org/gimp

set -exo pipefail

for x in babl gegl gimp libmypaint mypaint-brushes;do
    if [ ! -d /export/"${x}".git ]; then
        if [ "$x" = 'libmypaint' ]; then
            git clone --mirror https://github.com/mypaint/libmypaint.git /export/libmypaint.git
        elif [ "$x" = 'mypaint-brushes' ]; then
            git clone --mirror https://github.com/Jehan/mypaint-brushes.git /export/mypaint-brushes.git
        else
            git clone --mirror git://git.gnome.org/"${x}" /export/"${x}".git
        fi
    fi
    ( cd /export/"${x}".git; git remote update --prune )
done
