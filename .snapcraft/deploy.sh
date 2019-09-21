#!/bin/bash

set -o errexit

cd /root
snapcraft login --with .snapcraft/login_token
snapcraft push --release=edge output/latexml_fixed.snap