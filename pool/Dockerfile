FROM alpine as builder

ENV POOL_VERSION=v0.4.1-alpha

WORKDIR /opt

RUN apk --no-cache add \
    bash \
    ca-certificates \
    gnupg \
    perl-utils

RUN wget https://github.com/lightninglabs/pool/releases/download/${POOL_VERSION}/pool-linux-amd64-${POOL_VERSION}.tar.gz
RUN wget https://github.com/lightninglabs/pool/releases/download/${POOL_VERSION}/manifest-${POOL_VERSION}.txt
RUN wget https://github.com/lightninglabs/pool/releases/download/${POOL_VERSION}/manifest-${POOL_VERSION}.txt.sig

RUN wget -nv -O - https://keybase.io/roasbeef/pgp_keys.asc | gpg --import && \
    gpg --verify manifest-${POOL_VERSION}.txt.sig manifest-${POOL_VERSION}.txt && \
    cat  manifest-${POOL_VERSION}.txt | grep -q "$(shasum -a 256 pool-linux-amd64-${POOL_VERSION}.tar.gz)"

RUN tar -xvzf pool-linux-amd64-${POOL_VERSION}.tar.gz

FROM alpine as final

ENV POOL_VERSION=v0.4.1-alpha
ENV PUID=10002
ENV PGID=10002

COPY --from=builder /opt/pool-linux-amd64-${POOL_VERSION}/pool /usr/local/bin/
COPY --from=builder /opt/pool-linux-amd64-${POOL_VERSION}/poold /usr/local/bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid ${PGID} pool
RUN adduser pool --system --uid ${PUID} --home /pool -G pool

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 12010 8281

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["poold"]
