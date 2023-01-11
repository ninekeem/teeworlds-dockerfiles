FROM alpine:latest
RUN apk update
RUN apk add git icu-data-full npm nodejs

RUN git clone --depth 1 https://github.com/k0rae/tw-econ-antivpn
WORKDIR /tw-econ-antivpn

RUN npm install

ENTRYPOINT npm start