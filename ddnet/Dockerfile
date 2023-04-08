FROM alpine:latest AS build
RUN apk update
RUN apk add git
RUN git clone \
	--depth 1 \
	--single-branch \
	--no-tags \
	https://github.com/ddnet/ddnet

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

WORKDIR ddnet/build
RUN cmake .. -Wnodev \
	-DWEBSOCKETS=OFF \
	-DMYSQL=OFF \
	-DAUTOUPDATE=OFF \
	-DCLIENT=OFF \
	-DVIDEORECORDER=OFF \
	-DVULKAN=OFF \
	-GNinja \
	-DIPO=ON

RUN ninja

FROM alpine:latest
RUN apk update
RUN apk add --no-cache \
	cmd:ss \
	libcurl \
	libstdc++ \
	sqlite-libs
	
COPY --from=build /ddnet/build /ddnet
COPY ddnet.cfg /ddnet/data/autoexec_server.cfg
COPY *.sh /usr/local/bin/
WORKDIR /ddnet

ENV BANLIST_PATH=/root/.local/share/ddnet/banlist
ENV CFG=/ddnet/data/autoexec_server.cfg
ENV EXECUTABLE=/ddnet/DDNet-Server
ENTRYPOINT ["init.sh"]

ENV EC_PORT=8303
HEALTHCHECK \
	--interval=10s \
	--timeout=10s \
	--start-period=3s \
	--retries=2 \
	CMD ss -4lnt | grep "$EC_PORT" || exit 1
