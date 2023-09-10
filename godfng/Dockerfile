FROM alpine:latest AS bam
RUN apk update
RUN apk add --no-cache \
	gcc \
	git \
	musl-dev

RUN git clone \
	https://github.com/matricks/bam

WORKDIR /bam
RUN git checkout v0.4.0
RUN ./make_unix.sh

FROM alpine:latest AS build
RUN apk update
RUN apk add --no-cache \
	gcc \
	g++ \
	git \
	python3

RUN git clone \
	--depth 1 \
	--no-tags \
	https://github.com/35niavlys/teeworlds-godfng

WORKDIR /teeworlds-godfng
COPY --from=bam /bam /bam
RUN /bam/bam server_release

FROM alpine:latest
RUN apk update
RUN apk add --no-cache \
	cmd:ss \
	libstdc++

COPY --from=build /teeworlds-godfng /teeworlds-godfng
COPY godfng.cfg /teeworlds-godfng/default_config.cfg
COPY maps/*.map /teeworlds-godfng/data/maps/
COPY *.sh /usr/local/bin/
WORKDIR /teeworlds-godfng

ENV BANLIST_PATH=/root/.teeworlds/banlist
ENV CONFIG_PATH=/teeworlds-godfng/config/autoexec.cfg
ENV DEFAULT_CONFIG_PATH=/teeworlds-godfng/default_config.cfg
ENV EXEC_PATH=/teeworlds-godfng/fng2_srv
ENV MAPS_DIR=/teeworlds-godfng/data/maps
ENV VOTE_GENERATOR=true
ENTRYPOINT ["init.sh"]

ENV EC_PORT=8303
HEALTHCHECK \
	--interval=10s \
	--timeout=10s \
	--start-period=3s \
	--retries=2 \
	CMD ss -4lnt | grep -q "$EC_PORT" || exit 1
