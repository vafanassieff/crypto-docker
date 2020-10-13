FROM golang:1.13-alpine as builder

LABEL maintainer="victor@afanassieff.com"

ENV LIT_VERSION v0.2.0-alpha.rc4
ENV NODE_VERSION=v12.17.0
ENV OS linux
ENV ARCH amd64

WORKDIR /opt

RUN apk add --no-cache --update \
    alpine-sdk \
    gnupg \
    perl-utils \
    make \
    git \
    curl \
    bash \
    binutils \
    protobuf-dev

RUN curl -sfSLO https://unofficial-builds.nodejs.org/download/release/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64-musl.tar.xz \
    && tar -xf node-${NODE_VERSION}-linux-x64-musl.tar.xz -C /usr --strip 1 \
    && rm node-${NODE_VERSION}-linux-x64-musl.tar.xz

RUN npm install -g yarn

RUN wget https://github.com/lightninglabs/lightning-terminal/releases/download/${LIT_VERSION}/lightning-terminal-source-${LIT_VERSION}.tar.gz
RUN wget https://github.com/lightninglabs/lightning-terminal/releases/download/${LIT_VERSION}/vendor.tar.gz
RUN wget https://github.com/lightninglabs/lightning-terminal/releases/download/${LIT_VERSION}/manifest-${LIT_VERSION}.txt.asc
RUN wget https://github.com/lightninglabs/lightning-terminal/releases/download/${LIT_VERSION}/manifest-${LIT_VERSION}.txt


RUN wget -O - https://keybase.io/guggero/pgp_keys.asc | gpg --import
RUN gpg --verify manifest-${LIT_VERSION}.txt.asc

RUN tar -xvzf vendor.tar.gz
RUN tar -xvzf lightning-terminal-source-${LIT_VERSION}.tar.gz

RUN make install \
    && go install -v -trimpath github.com/lightningnetwork/lnd/cmd/lncli \
    && go install -v -trimpath github.com/lightninglabs/faraday/cmd/frcli \
    && go install -v -trimpath github.com/lightninglabs/loop/cmd/loop

FROM alpine

LABEL maintainer="victor@afanassieff.com"

ENV LIT_VERSION v0.2.0-alpha.rc4
ENV NODE_VERSION=v12.17.0

COPY --from=builder /go/bin/litd  /usr/local/bin/
COPY --from=builder /go/bin/lncli  /usr/local/bin/
COPY --from=builder /go/bin/frcli  /usr/local/bin/
COPY --from=builder /go/bin/loop  /usr/local/bin/

RUN apk add \
    libressl \
    su-exec \
    shadow \
    bash \
    jq \
    ca-certificates

RUN addgroup --system lit
RUN adduser lit --system --home /lit -G lit

VOLUME ["/lit/.lit"]

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8443

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["litd"]
