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
		--branch refng \
		--single-branch \
		--no-tags \
		--recursive \
	https://github.com/k0rae/teeworlds

WORKDIR /teeworlds/build
RUN cmake .. -Wno-dev -DCLIENT=OFF

RUN make install -j$(nproc)

FROM alpine:latest
RUN apk add --no-cache libstdc++
COPY --from=build /usr/local/share/teeworlds/ /usr/local/share/teeworlds/
COPY --from=build /usr/local/bin/ /usr/local/bin/
WORKDIR /usr/local/share/teeworlds/data/
ENTRYPOINT ["teeworlds_srv"]
