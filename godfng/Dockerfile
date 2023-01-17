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
WORKDIR /teeworlds-godfng
ENTRYPOINT ["./fng2_srv"]
