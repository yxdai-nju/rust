#!/usr/bin/bash
set -e

# Create an absolute path symlink to standard library source
if [ -e ./src ]; then
    if [ -L ./src ]; then
        rm ./src
    else
        exit 1
    fi
fi
ln -s $(realpath ../../library) ./src

# Generate BUCK files for third-party dependencies
reindeer --third-party-dir . buckify
