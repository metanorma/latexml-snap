#!/bin/bash

set -o errexit

cd /root 
apt-get install -y squashfs-tools python3
unsquashfs output/latexml_*_amd64.snap
# snapcraft pack squashfs-root
mksquashfs ./squashfs-root output/latexml_fixed.snap -noappend -comp xz -all-root -no-xattrs -no-fragments