FROM ubuntu:trusty

MAINTAINER Joshua Gardner mellowcellofellow@gmail.com

# Set Locale

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8



# Enable Universe and Multiverse and install dependencies.

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe multiverse >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get -y install autoconf automake build-essential git mercurial cmake libass-dev libgpac-dev libtheora-dev libtool libvdpau-dev libvorbis-dev pkg-config texi2html zlib1g-dev libmp3lame-dev wget yasm openssl libssl-dev; \
    apt-get clean

# Run build script

ADD script/build.sh /build.sh
RUN ["/bin/bash", "/build.sh"]

CMD ["/bin/bash"]
