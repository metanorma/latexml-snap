#!/bin/bash

set -o errexit

cd /root
apt update
snapcraft --version
snapcraft snap
cp latexml_*_amd64.snap ./output/latexml_fixed.snap