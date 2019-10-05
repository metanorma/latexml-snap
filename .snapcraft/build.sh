#!/bin/bash

set -o errexit

cd /root
apt update
snapcraft --version
snapcraft snap --output output/latexml.snap