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
	cmd:ss \
	libstdc++

COPY --from=build /usr/local/share/teeworlds/ /usr/local/share/teeworlds/
COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY teeworlds.cfg /usr/local/share/teeworlds/data/autoexec.cfg
COPY *.sh /usr/local/bin/
WORKDIR /usr/local/share/teeworlds/data/

ENV BANLIST_PATH=/root/.teeworlds/banlist
ENV CFG=/usr/local/share/teeworlds/data/autoexec.cfg
ENV EXECUTABLE=/usr/local/bin/teeworlds_srv
ENV VOTE_GENERATOR=false
ENTRYPOINT ["init.sh"]

ENV EC_PORT=8303
HEALTHCHECK \
	--interval=10s \
	--timeout=10s \
	--start-period=3s \
	--retries=2 \
	CMD ss -4lnt | grep "$EC_PORT" || exit 1
