#!/bin/bash

# start extracting the filesystem
binwalk -e dcs930lb1_v2.14.04.bin && \
  cd _dcs930lb1_v2.14.04.bin.extracted
binwalk -e 50040 && \
  cd _50040.extracted
binwalk -e 3AC000 && \
  cd _3AC000.extracted
  cd cpio-root
