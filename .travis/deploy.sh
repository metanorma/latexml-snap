#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

cat snap_token | snapcraft login --with -
snapcraft push --release=edge latexml_*_amd64.snap