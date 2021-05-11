FROM alpine as builder

ENV FARADAY_VERSION=v0.2.3-alpha

WORKDIR /opt

RUN apk --no-cache add \
    bash \
    ca-certificates \
    gnupg \
    perl-utils

RUN wget https://github.com/lightninglabs/faraday/releases/download/${FARADAY_VERSION}/faraday-linux-amd64-${FARADAY_VERSION}.tar.gz
RUN wget https://github.com/lightninglabs/faraday/releases/download/${FARADAY_VERSION}/manifest-${FARADAY_VERSION}.txt
RUN wget https://github.com/lightninglabs/faraday/releases/download/${FARADAY_VERSION}/manifest-${FARADAY_VERSION}.txt.sig

RUN wget -nv -O - https://keybase.io/carlakirkcohen/pgp_keys.asc | gpg --import && \
    gpg --verify manifest-${FARADAY_VERSION}.txt.sig manifest-${FARADAY_VERSION}.txt && \
    cat  manifest-${FARADAY_VERSION}.txt | grep -q "$(shasum -a 256 faraday-linux-amd64-${FARADAY_VERSION}.tar.gz)"

RUN tar -xvzf faraday-linux-amd64-${FARADAY_VERSION}.tar.gz

FROM alpine as final

ENV FARADAY_VERSION=v0.2.3-alpha
ENV PUID=10001
ENV PGID=10001

COPY --from=builder /opt/faraday-linux-amd64-${FARADAY_VERSION}/faraday /usr/local/bin/
COPY --from=builder /opt/faraday-linux-amd64-${FARADAY_VERSION}/frcli /usr/local/bin/

RUN apk --no-cache add \
    su-exec \
    shadow

RUN addgroup --system --gid ${PGID} faraday
RUN adduser faraday --system --uid ${PUID} --home /faraday -G faraday

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 8465

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["faraday"]