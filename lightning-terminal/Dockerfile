FROM alpine as builder

ENV LIT_VERSION=v0.6.0-alpha

WORKDIR /opt

RUN apk --no-cache add \
    bash \
    ca-certificates \
    gnupg \
    perl-utils

RUN wget https://github.com/lightninglabs/lightning-terminal/releases/download/${LIT_VERSION}/lightning-terminal-linux-amd64-${LIT_VERSION}.tar.gz
RUN wget https://github.com/lightninglabs/lightning-terminal/releases/download/${LIT_VERSION}/manifest-${LIT_VERSION}.txt
RUN wget https://github.com/lightninglabs/lightning-terminal/releases/download/${LIT_VERSION}/manifest-${LIT_VERSION}.sig

RUN wget -nv -O - https://keybase.io/guggero/pgp_keys.asc | gpg --import && \
    gpg --verify manifest-${LIT_VERSION}.sig manifest-${LIT_VERSION}.txt && \
    cat  manifest-${LIT_VERSION}.txt | grep -q "$(shasum -a 256 lightning-terminal-linux-amd64-${LIT_VERSION}.tar.gz)"

RUN tar -xvzf lightning-terminal-linux-amd64-${LIT_VERSION}.tar.gz

FROM alpine as final

ENV LIT_VERSION=v0.6.0-alpha
ENV PUID=10003
ENV PGID=10003

COPY --from=builder /opt/lightning-terminal-linux-amd64-${LIT_VERSION}/litd /usr/local/bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid ${PGID} lit
RUN adduser lit --system --uid ${PUID} --home /lit -G lit

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 443

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["litd"]
