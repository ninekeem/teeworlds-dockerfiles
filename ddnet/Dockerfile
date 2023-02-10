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
	-DWEBSOCKERS=ON \
	-DMYSQL=OFF \
	-DAUTOUPDATE=OFF \
	-DCLIENT=OFF \
	-DVIDEORECORDER=OFF \
	-DVULKAN=OFF \
	-GNinja \
	-DIPO=OFF

RUN ninja

FROM alpine:latest
RUN apk update
RUN apk add --no-cache \
	libcurl \
	libgcc \
	libstdc++ \
	sqlite-libs
	
COPY --from=build /ddnet/build /ddnet
COPY ddnet.cfg /ddnet/data/autoexec_server.cfg
COPY DDNet-Server.sh /ddnet/DDNet-Server.sh
WORKDIR /ddnet
ENTRYPOINT ["./DDNet-Server.sh"]
