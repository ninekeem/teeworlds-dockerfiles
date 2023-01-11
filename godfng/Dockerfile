FROM debian:stable-slim AS build

RUN apt update
RUN apt install git build-essential python3 -y

RUN git clone --depth 1 https://github.com/35niavlys/teeworlds-godfng
WORKDIR /teeworlds-godfng

COPY --from=bam:0.4.0 /bam /bam

RUN /bam/bam server_release
RUN find / -iname 'fng.cfg'
ENTRYPOINT ["./fng2_srv -f fng.cfg"]
