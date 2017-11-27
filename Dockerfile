FROM ubuntu
#FROM debian

# install os dependencies
RUN apt update && apt install -y wget unzip python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# install binwalk
RUN wget https://github.com/devttys0/binwalk/archive/master.zip && \
  unzip master.zip && \
  rm -rf master.zip && \
  cd binwalk-master && \
  python3 setup.py install

# install binwalk dependencies
RUN /binwalk-master/deps.sh --yes

# download and extract firmware
RUN wget http://d2okd4tdjucp2n.cloudfront.net/DCS-930LB1/DCS-930L_Bx_FW_v2.14.04.zip && \
  unzip DCS-930L_Bx_FW_v2.14.04.zip

# copy in the extraction script
COPY extract.sh /
RUN /extract.sh

# change workdir to the dlink root
WORKDIR /_dcs930lb1_v2.14.04.bin.extracted/_50040.extracted/_3AC000.extracted/cpio-root/
