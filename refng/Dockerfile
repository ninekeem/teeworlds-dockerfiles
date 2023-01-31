FROM alpine:latest AS build

RUN apk add --no-cache \
		git \
		cmake \
		curl-dev \
		make \
		g++ \
		gcc \
		python3 \
		sqlite-dev \
		zlib-dev

RUN git clone \
		--depth 1 \
		--branch fng_06 \
		--single-branch \
		--no-tags \
		#--recursive \
		https://github.com/k0rae/refng

WORKDIR /refng/build
RUN cmake .. \
	-Wno-dev

RUN make install -j$(nproc)

FROM alpine:latest
RUN apk add --no-cache cmd:ss libstdc++
COPY --from=build /usr/local/share/fng/ /usr/local/share/fng/
COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY refng.cfg /usr/local/share/fng/data/autoexec.cfg
COPY maps/*.map /usr/local/share/fng/data/maps/
COPY refng.sh /usr/local/bin/refng.sh
WORKDIR /usr/local/share/fng/data/
ENTRYPOINT ["refng.sh"]
ENV EC_PORT=8303
HEALTHCHECK \
	--interval=10s \
	--timeout=10s \
	--start-period=3s \
	--retries=2 \
	CMD ss -4lt | grep "$EC_PORT"
