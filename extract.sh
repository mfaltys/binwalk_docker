#!/bin/bash

binwalk -e dcs930lb1_v2.14.04.bin
cd _dcs930lb1_v2.14.04.bin.extracted
binwalk -e 50040
cd _50040.extracted
binwalk -e 3AC000
cd _3AC000.extracted
cd cpio-root

# areas of note:
#   /sbin/chpasswd.sh
#   /etc_ro/servercert.pem
#   /etc_ro/serverkey.pem
#   /etc_ro/rcS
#   /usr/sbin/telnetd
#   /sbin/snort.sh leads us to belive snort is installed at /bin/snort.. it is not
