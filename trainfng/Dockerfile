FROM alpine:latest AS build

RUN apk update
RUN apk add git \
			cmake \
			curl-dev \
			make \
			g++ \
			gcc \
			libpng-dev \
			python3 \
			sqlite-dev \
			zlib-dev

RUN git clone --depth 1 https://github.com/35niavlys/teeworlds-trainfng

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
RUN apk add --no-cache curl-dev libstdc++ sqlite-dev
COPY --from=build /usr/local/share/ddnet/ /usr/local/share/ddnet/
COPY --from=build /usr/local/bin/ /usr/local/bin/
WORKDIR /usr/local/share/ddnet/data/
ENTRYPOINT ["TrainFNG-Server"]
