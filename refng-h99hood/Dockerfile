FROM debian:stable-slim AS build

RUN apt update && \
    apt install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    libcurl4-openssl-dev \
    libpqxx-dev \
	git \
    python3

RUN git clone \
	--depth 1 \
	--branch fng_06 \
	--single-branch \
	--no-tags \
	--recursive \
	https://github.com/h99developer/refng

WORKDIR /refng/build
RUN cmake .. \
	-Wno-dev

RUN make -j$(nproc)

FROM debian:stable-slim
RUN apt update && \
    apt install -y --no-install-recommends \
    libpqxx-6.4 \
    libstdc++6

COPY --from=build /refng/build /refng
COPY autoexec.cfg /refng/default_config.cfg
COPY maps/*.map /refng/data/maps
COPY *.sh /usr/local/bin/
WORKDIR /refng

ENV BANLIST_PATH=/root/.teeworlds/banlist
ENV CONFIG_PATH=/refng/config/autoexec.cfg
ENV DEFAULT_CONFIG_PATH=/refng/default_config.cfg
ENV EXEC_PATH=/refng/fng2_srv
ENV MAPS_DIR=/refng/data/maps
ENV VOTE_GENERATOR=true
ENTRYPOINT ["init.sh"]

ENV EC_PORT=8303
HEALTHCHECK \
	--interval=10s \
	--timeout=10s \
	--start-period=3s \
	--retries=2 \
	CMD ss -4lnt | grep -q "$EC_PORT" || exit 1
