#!/bin/bash

set -o errexit

cd /root 
apt-get install -y squashfs-tools python3
unsquashfs output/latexml.snap
sudo chmod -R g-s ./squashfs-root
snapcraft pack squashfs-root --output output/latexml_fixed.snap
# mksquashfs ./squashfs-root output/latexml_fixed.snap -noappend -comp xz -all-root -no-xattrs -no-fragments