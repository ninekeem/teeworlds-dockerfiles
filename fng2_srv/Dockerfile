FROM alpine:latest AS build

RUN apk add --no-cache \
		git \
		cmake \
		make \
		g++ \
		gcc \
		python3 \
		zlib-dev

RUN git clone \
		--depth 1 \
		-b fng_06 \ 
		--single-branch \
	https://github.com/Jupeyy/teeworlds-fng2-mod

WORKDIR /teeworlds-fng2-mod
RUN sed -i 's/MAX_CLIENTS=16/MAX_CLIENTS=64/' src/engine/shared/protocol.h
RUN sed -i 's/NET_MAX_CLIENTS = 16/NET_MAX_CLIENTS = 64/' src/engine/shared/network.h

WORKDIR /teeworlds-fng2-mod/build
RUN cmake .. -Wno-dev

RUN make install -j$(nproc)

FROM alpine:latest
RUN apk add --no-cache libstdc++
COPY --from=build /usr/local/share/fng/ /usr/local/share/fng/
COPY --from=build /usr/local/bin/ /usr/local/bin/
WORKDIR /usr/local/share/fng/data/
ENTRYPOINT ["fng2_srv"]
