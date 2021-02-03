FROM golang:1.15.7-alpine as lnd

LABEL maintainer="victor@afanassieff.com"

ENV LND_VERSION v0.12.0-beta
ENV OS linux
ENV ARCH amd64
ENV GODEBUG netdns=cgo

RUN apk add --no-cache --update \
    alpine-sdk \
    gnupg \
    make \
    gcc

WORKDIR /opt

RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/lnd-source-${LND_VERSION}.tar.gz
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/manifest-${LND_VERSION}.txt
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/manifest-roasbeef-${LND_VERSION}.txt.asc
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/manifest-bitconner-${LND_VERSION}.txt.asc

RUN wget -O - https://keybase.io/bitconner/pgp_keys.asc | gpg --import && \
    wget -O - https://keybase.io/roasbeef/pgp_keys.asc | gpg --import && \
    gpg --verify manifest-roasbeef-${LND_VERSION}.txt.asc && \
    gpg --verify manifest-bitconner-${LND_VERSION}.txt.asc && \
    grep -q $(sha256sum lnd-source-${LND_VERSION}.tar.gz | cut -d ' ' -f1) manifest-bitconner-${LND_VERSION}.txt.asc || exit 1 && \
    grep -q $(sha256sum lnd-source-${LND_VERSION}.tar.gz | cut -d ' ' -f1) manifest-roasbeef-${LND_VERSION}.txt.asc || exit 1

RUN tar -xvzf lnd-source-v0.12.0-beta.tar.gz && \
    cd lnd-source \
    &&  make \
    &&  make install tags="autopilotrpc chainrpc invoicesrpc routerrpc signrpc walletrpc watchtowerrpc wtclientrpc monitoring verrpc"

FROM alpine

LABEL maintainer="victor@afanassieff.com"

ENV LND_CONF_PATH=/conf/lnd.conf

COPY --from=lnd /go/bin/lncli /usr/local/bin/
COPY --from=lnd /go/bin/lnd /usr/local/bin/

RUN apk add \
    su-exec \
    shadow


RUN addgroup --system --gid 10000 lnd
RUN adduser lnd --system --uid 10000 --home /lnd -G lnd

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 9735 9911 10009 8080

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["lnd"]
