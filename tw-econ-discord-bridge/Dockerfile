FROM alpine:latest

RUN apk add --no-cache \
		git \
		icu-data-full \
		nodejs \
		npm

RUN git clone \
		--no-tags \
	https://github.com/k0rae/tw-econ-discord-bridge

WORKDIR /tw-econ-discord-bridge
RUN npm install

ENTRYPOINT ["npm", "start"]
