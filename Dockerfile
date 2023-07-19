#FROM ubuntu:20.10 AS build
FROM ubuntu:22.04 AS build

RUN apt-get update \
  && apt-get install -y bison flex g++ make patch wget xz-utils \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
COPY gbdk.patch .

RUN wget ftp://ftp.gnu.org/pub/gnu/sed/sed-4.5.tar.xz \
  && wget https://sourceforge.net/projects/gbdk/files/gbdk/2.96/gbdk-2.96a.tar.gz \
  && wget https://sourceforge.net/projects/gbdk/files/maccer/0.25/maccer-0.25.tar.gz \
  && tar xfJ sed-4.5.tar.xz \
  && tar xfz gbdk-2.96a.tar.gz \
  && tar xfz maccer-0.25.tar.gz -C gbdk \
  && cd sed-4.5 \
  && mkdir build \
  && cd build \
  && ../configure \
  && make \
  && make install-strip \
  && cd ../.. \
  && find gbdk/gbdk-lib/examples -type f -exec chmod -x {} \; \
  && find gbdk/gbdk-lib/include -type f -exec chmod -x {} \; \
  && patch -p0 < gbdk.patch \
  && cd gbdk \
  && make install \
  && find /opt/gbdk -type f \( -name \*.asm -o -name \*.lst -o -name \*.sym \) -exec rm {} \;

#FROM ubuntu:20.10
FROM ubuntu:22.04

USER root
RUN apt-get update \
  && apt-get install -y make \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get -yq update && apt-get install -y git wget
RUN export PATH=$PATH:/workdir/tobutobugirl/pyimgtogb
RUN export GBDKDIR=/opt/gbdk/
RUN apt-get install -y python3
RUN apt-get install -y pip
RUN python3 -m pip install git+https://gitlab.com/drj11/pypng@pypng-0.20220715.0
COPY --from=build /opt/gbdk /opt/gbdk
#ENV PATH /opt/gbdk/bin:$PATH
WORKDIR /workdir
RUN git clone --recursive https://github.com/SimonLarsen/tobutobugirl
WORKDIR /workdir/tobutobugirl
RUN cd /workdir/tobutobugirl
RUN wget https://github.com/SimonLarsen/mmlgb/releases/download/v0.1/MMLGB.jar
RUN git clone https://github.com/SimonLarsen/pyimgtogb
RUN apt-get install -y openjdk-8-jre-headless
RUN pip install numpy
#RUN make
