#!/usr/bin/bash
set -e

# Generate BUCK files for third-party dependencies
reindeer --third-party-dir . buckify
