#!/bin/bash

set -o errexit

cd /root 
apt-get install -y squashfs-tools
unsquashfs output/latexml_*_amd64.snap
mksquashfs ./squashfs-root output/latexml_fixed.snap -noappend -comp xz -all-root -no-xattrs -no-fragments