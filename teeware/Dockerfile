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
RUN apk add git
RUN git clone \
	--depth 1 \
	--single-branch \
	--no-tags \
	https://github.com/headshot2017/teeware-mod

RUN apk add --no-cache \
	cargo \
	cmake \
	curl-dev \
	gcc \ 
	g++ \
	libpng-dev \
	ninja \
	python3 \
	sqlite-dev

WORKDIR teeware-mod/
COPY --from=bam /bam /bam
RUN /bam/bam server_release

FROM alpine:latest
RUN apk update
RUN apk add --no-cache \
	cmd:ss \
	libcurl \
	libstdc++ \
	sqlite-libs
	
COPY --from=build /teeware-mod /teeware
COPY teeware.cfg /teeware/default_config.cfg
COPY *.sh /usr/local/bin/
WORKDIR /teeware

ENV BANLIST_PATH=/root/.teeworlds/banlist
ENV DEFAULT_CONFIG_PATH=/teeware/default_config.cfg
ENV CONFIG_PATH=/teeware/config/autoexec_server.cfg
ENV EXEC_PATH=/teeware/TeeWare
ENV VOTE_GENERATOR=false
ENTRYPOINT ["init.sh"]

ENV EC_PORT=8303
HEALTHCHECK \
	--interval=10s \
	--timeout=10s \
	--start-period=3s \
	--retries=2 \
	CMD ss -4lnt | grep -q "$EC_PORT" || exit 1
