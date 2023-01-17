FROM alpine:latest

RUN apk add --no-cache \
        git \
        icu-data-full \
        npm \
        nodejs

RUN git clone \
        --depth 1 \
    https://github.com/k0rae/tw-econ-antivpn

WORKDIR /tw-econ-antivpn
RUN npm install

ENTRYPOINT npm start