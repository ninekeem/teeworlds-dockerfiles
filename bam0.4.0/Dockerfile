FROM debian:oldstable-slim AS build

RUN apt update
RUN apt install git build-essential -y

RUN git clone --depth 1 \
              -b 0.4.0 \
              --single-branch \
              https://github.com/matricks/bam

WORKDIR /bam
RUN ./make_unix.sh