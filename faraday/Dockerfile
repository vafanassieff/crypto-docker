FROM alpine:3.16 as builder

ENV FARADAY_VERSION=v0.2.8-alpha

WORKDIR /opt

RUN apk --no-cache add \
    bash \
    ca-certificates \
    gnupg \
    perl-utils

RUN wget https://github.com/lightninglabs/faraday/releases/download/${FARADAY_VERSION}/faraday-linux-amd64-${FARADAY_VERSION}.tar.gz
RUN wget https://github.com/lightninglabs/faraday/releases/download/${FARADAY_VERSION}/manifest-${FARADAY_VERSION}.txt
RUN wget https://github.com/lightninglabs/faraday/releases/download/${FARADAY_VERSION}/manifest-${FARADAY_VERSION}.sig

RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys F4FC70F07310028424EFC20A8E4256593F177720 && \
    gpg --verify manifest-${FARADAY_VERSION}.sig manifest-${FARADAY_VERSION}.txt && \
    cat  manifest-${FARADAY_VERSION}.txt | grep -q "$(shasum -a 256 faraday-linux-amd64-${FARADAY_VERSION}.tar.gz)"

RUN tar -xvzf faraday-linux-amd64-${FARADAY_VERSION}.tar.gz

FROM alpine:3.16 as final

ENV FARADAY_VERSION=v0.2.8-alpha
ENV PUID=10001
ENV PGID=10001

COPY --from=builder /opt/faraday-linux-amd64-${FARADAY_VERSION}/faraday /usr/local/bin/faraday
COPY --from=builder /opt/faraday-linux-amd64-${FARADAY_VERSION}/frcli /usr/local/bin/frcli

RUN apk --no-cache add \
    su-exec \
    shadow \
    libc6-compat

RUN addgroup --system --gid ${PGID} faraday
RUN adduser faraday --system --uid ${PUID} --home /faraday -G faraday

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 8465

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["faraday"]
