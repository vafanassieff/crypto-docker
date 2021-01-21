FROM golang:1.14.9-alpine as lnd

LABEL maintainer="victor@afanassieff.com"

ENV LND_VERSION v0.11.1-beta
ENV OS linux
ENV ARCH amd64
ENV GODEBUG netdns=cgo

RUN apk add \
    gnupg \
    perl-utils\
    make \
    gcc

WORKDIR /opt

RUN wget https://github.com/lightningnetwork/lnd/archive/${LND_VERSION}.tar.gz
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/manifest-${LND_VERSION}.txt.sig
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/manifest-${LND_VERSION}.txt
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/roasbeef-manifest-${LND_VERSION}.txt.sig

RUN wget -O - https://keybase.io/bitconner/pgp_keys.asc | gpg --import
RUN gpg --verify manifest-v0.11.1-beta.txt.sig

RUN tar -xvzf ${LND_VERSION}.tar.gz
RUN ls -la && cd lnd-${LND_VERSION:1} \
    &&  make \
    &&  make install tags="autopilotrpc chainrpc invoicesrpc routerrpc signrpc walletrpc watchtowerrpc wtclientrpc monitoring"

FROM alpine

LABEL maintainer="victor@afanassieff.com"

ENV LND_VERSION v0.11.1-beta
ENV LND_PATH=/lnd
ENV LND_CONF_PATH=$LND_PATH/.lnd/lnd.conf

COPY --from=lnd /go/bin/lncli /usr/local/bin/
COPY --from=lnd /go/bin/lnd /usr/local/bin/

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
