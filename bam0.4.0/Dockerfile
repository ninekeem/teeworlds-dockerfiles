FROM debian:oldstable-slim AS build

RUN apt update && apt install git build-essential -y

RUN git clone https://github.com/matricks/bam

WORKDIR /bam
RUN git checkout v0.4.0
RUN ./make_unix.sh