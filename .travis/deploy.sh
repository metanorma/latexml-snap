#!/bin/bash

# Set an option to exit immediately if any error appears
set -o errexit

snapcraft login --with .snapcraft/snapcraft.cfg
snapcraft push --release=edge docker.snap