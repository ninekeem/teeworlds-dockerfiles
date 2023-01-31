FROM alpine:latest AS build

RUN apk add --no-cache \
		git \
		cmake \
		curl-dev \
		make \
		g++ \
		gcc \
		libpng-dev \
		python3 \
		sqlite-dev \
		zlib-dev

RUN git clone \
		--depth 1 \
		--single-branch \
		--no-tags \
	https://github.com/35niavlys/teeworlds-trainfng

WORKDIR /teeworlds-trainfng/build
RUN cmake .. \
	-Wno-dev \
	-DAUTOUPDATE=OFF \
	-DCLIENT=OFF \
	-DMYSQL=OFF \
	-DVIDEORECORDER=OFF \
	-DUPNP=OFF

RUN make install -j$(nproc)

FROM alpine:latest
RUN apk add --no-cache cmd:ss libcurl libstdc++ sqlite-dev
COPY --from=build /usr/local/share/ddnet/ /usr/local/share/ddnet/
COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY trainfng.cfg /usr/local/share/ddnet/data/autoexec_server.cfg
COPY maps/*.map /usr/local/share/ddnet/data/maps/
COPY TrainFNG.sh /usr/local/bin/TrainFNG.sh
WORKDIR /usr/local/share/ddnet/data/
ENTRYPOINT ["TrainFNG.sh"]
ENV EC_PORT=8303
HEALTHCHECK \
	--interval=10s \
	--timeout=10s \
	--start-period=3s \
	--retries=2 \
	CMD ss -4lt | grep "$EC_PORT"
