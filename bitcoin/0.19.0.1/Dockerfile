FROM alpine as bitcoin

LABEL maintainer="victor@afanassieff.com"

ARG CORE_COUNT=4
ENV BITCOIN_VERSION=0.19.0.1

WORKDIR /opt

RUN apk update && apk add \
    make \
    file \
    autoconf \
    automake \ 
    build-base \
    libtool \
    boost-system \
    boost-program_options \
    boost-filesystem \ 
    boost-dev \ 
    libressl-dev \ 
    libevent-dev \
    zeromq-dev  \
    gnupg

RUN wget https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc
RUN wget https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}.tar.gz
RUN grep "bitcoin-${BITCOIN_VERSION}.tar.gz\$" SHA256SUMS.asc | sha256sum -c -
RUN gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964
RUN gpg --verify SHA256SUMS.asc
RUN tar -xzf bitcoin-${BITCOIN_VERSION}.tar.gz

WORKDIR /opt/bitcoin-${BITCOIN_VERSION}

RUN ./autogen.sh
RUN ./configure \
    --prefix=/opt/bitcoin-build \ 
    --disable-wallet \
    --without-gui \
    --enable-hardening \
    --disable-tests \
    --disable-bench \
    --disable-ccache \
    --with-utils \
    --with-libs \
    --with-daemon \
    --without-miniupnpc

RUN make -j ${CORE_COUNT}
RUN make install

RUN strip /opt/bitcoin-build/bin/bitcoind && \
    strip /opt/bitcoin-build/bin/bitcoin-tx && \
    strip /opt/bitcoin-build/bin/bitcoind

FROM alpine

LABEL maintainer="victor@afanassieff.com"

ENV BITCOIN_VERSION=0.19.0.1

COPY --from=bitcoin /opt/bitcoin-build /usr/local/

RUN addgroup --system bitcoin
RUN adduser bitcoin --system --home /bitcoin -G bitcoin

RUN apk add \
    boost \
    libevent \
    libressl \
    libzmq \
    su-exec \
    shadow

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18444

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["bitcoind"]
