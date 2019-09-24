#!/bin/bash

set -o errexit

cd /root
snapcraft login --with .snapcraft/snapcraft.cfg
snapcraft push --release=edge output/latexml_fixed.snap