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
COPY godfng.cfg /teeworlds-godfng/autoexec.cfg
COPY maps/*.map /teeworlds-godfng/data/maps/
COPY godfng.sh /usr/local/bin/godfng.sh
WORKDIR /teeworlds-godfng
ENTRYPOINT ["godfng.sh"]
ENV EC_PORT=8303
HEALTHCHECK \
	--interval=10s \
	--timeout=10s \
	--start-period=3s \
	--retries=2 \
	CMD ss -4lnt | grep "$EC_PORT"
