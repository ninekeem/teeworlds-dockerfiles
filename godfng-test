FROM debian:stable-slim AS build
RUN apt update
RUN apt install -y git
RUN git clone https://github.com/k0rae/teeworlds-godfng
RUN apt install -y build-essential
RUN apt install -y python3
COPY --from=bam:0.4.0 /bam /bam
WORKDIR teeworlds-godfng
RUN /bam/bam server_release
RUN find / -iname 'fng.cfg'
ENTRYPOINT ["./fng2_srv -f fng.cfg"]
