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
	--branch 0.6 \
	--single-branch \
	--recursive \
	https://github.com/teeworlds/teeworlds

WORKDIR /teeworlds/build
RUN cmake .. \
	-Wno-dev \
	-DCLIENT=OFF
RUN make install -j$(nproc)

FROM alpine:latest
RUN apk add --no-cache \
	curl-dev \
	cmd:ss \
	libstdc++ \
	sqlite-dev

COPY --from=build /usr/local/share/teeworlds/ /usr/local/share/teeworlds/
COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY teeworlds.cfg /usr/local/share/teeworlds/data/autoexec.cfg
COPY teeworlds_srv.sh /usr/local/bin/teeworlds_srv.sh
WORKDIR /usr/local/share/teeworlds/data/
ENTRYPOINT ["teeworlds_srv.sh"]
ENV EC_PORT=8303
HEALTHCHECK \
	--interval=10s \
	--timeout=10s \
	--start-period=3s \
	--retries=2 \
	CMD ss -4lt | grep "$EC_PORT"
