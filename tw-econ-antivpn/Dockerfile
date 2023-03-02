FROM golang:alpine as build

WORKDIR /app

RUN apk add alpine-sdk

COPY . .
RUN go build

FROM alpine:latest

COPY --from=build /app/tw-econ-antivpn /
ENTRYPOINT ["/tw-econ-antivpn"]
