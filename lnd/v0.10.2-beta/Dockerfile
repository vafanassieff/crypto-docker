FROM golang:1.13.10-alpine as lnd

LABEL maintainer="victor@afanassieff.com"

ENV LND_VERSION v0.10.2-beta
ENV OS linux
ENV ARCH amd64

RUN apk add \
    gnupg \
    perl-utils

WORKDIR /opt

RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/lnd-source-${LND_VERSION}.tar.gz
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/vendor.tar.gz
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/manifest-${LND_VERSION}.txt.sig
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/manifest-${LND_VERSION}.txt
RUN wget -O - https://keybase.io/roasbeef/pgp_keys.asc | gpg --import
RUN gpg --verify manifest-${LND_VERSION}.txt.sig || exit 1
RUN shasum -c manifest-${LND_VERSION}.txt --ignore-missing || exit 1

RUN tar -xvzf vendor.tar.gz
RUN tar -xvzf lnd-source-${LND_VERSION}.tar.gz

RUN CGO_ENABLED=0 GOOS=${OS} GOARCH=${ARCH} GO111MODULE=on go build -v -mod=vendor -trimpath \
    -tags="autopilotrpc chainrpc invoicesrpc routerrpc signrpc walletrpc watchtowerrpc wtclientrpc monitoring" \
    -ldflags "-s -w -buildid= -X github.com/lightningnetwork/lnd/build.Commit=${LND_VERSION}" ./cmd/lnd
RUN CGO_ENABLED=0 GOOS=${OS} GOARCH=${ARCH} GO111MODULE=on go build -v -mod=vendor -trimpath \
    -tags="autopilotrpc chainrpc invoicesrpc routerrpc signrpc walletrpc watchtowerrpc wtclientrpc monitoring" \
    -ldflags "-s -w -buildid= -X github.com/lightningnetwork/lnd/build.Commit=${LND_VERSION}" ./cmd/lncli

FROM alpine

LABEL maintainer="victor@afanassieff.com"

ENV LND_VERSION v0.10.2-beta

COPY --from=lnd /opt/lncli /usr/local/bin/
COPY --from=lnd /opt/lnd /usr/local/bin/

RUN apk add \
    libressl \
    su-exec \
    shadow

RUN addgroup --system lnd
RUN adduser lnd --system --home /lnd -G lnd

VOLUME ["/lnd/.lnd"]

COPY entrypoint.sh /entrypoint.sh

EXPOSE 9735 9911 10009 8080

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["lnd"]
