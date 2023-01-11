FROM alpine:latest AS build

RUN apk update
RUN apk add git \
			cmake \
			curl-dev \
			make \
			g++ \
			gcc \
			python3 \
			sqlite-dev \
			zlib-dev

RUN git clone --depth 1 \
			  -b 0.6 \
			  --single-branch \
			  --recursive \
			  https://github.com/teeworlds/teeworlds

WORKDIR /teeworlds/build
RUN cmake .. -Wno-dev -DCLIENT=OFF
RUN make install -j$(nproc)

FROM alpine:latest
RUN apk add --no-cache curl-dev libstdc++ sqlite-dev
COPY --from=build /usr/local/share/teeworlds/ /usr/local/share/teeworlds/
COPY --from=build /usr/local/bin/ /usr/local/bin/
WORKDIR /usr/local/share/teeworlds/data/
ENTRYPOINT ["teeworlds_srv"]
