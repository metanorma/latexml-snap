#!/bin/bash

set -o errexit

cd /root
apt update
snapcraft --version
snapcraft
cp latexml_*_amd64.snap ./output/