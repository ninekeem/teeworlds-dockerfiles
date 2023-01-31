FROM debian:stable-slim AS build

RUN apt update && apt install \
		git \
		build-essential \
		python3 -y

RUN git clone \
		--depth 1 \
		--no-tags \
	https://github.com/35niavlys/teeworlds-godfng

WORKDIR /teeworlds-godfng
COPY --from=bam:0.4.0 /bam /bam
RUN /bam/bam server_release

FROM debian:stable-slim
COPY --from=build /teeworlds-godfng /teeworlds-godfng
COPY godfng.cfg /teeworlds-godfng/autoexec.cfg
COPY maps/*.map /teeworlds-godfng/data/maps/
COPY godfng.sh /usr/local/bin/godfng.sh
WORKDIR /teeworlds-godfng
ENTRYPOINT ["godfng.sh"]
