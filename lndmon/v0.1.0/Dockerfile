FROM golang:1.13-alpine as builder

LABEL maintainer="victor@afanassieff.com"

ENV LNDMON_VERSION v0.1.0
ENV GO111MODULE on

RUN apk add --no-cache --update alpine-sdk \
    musl-dev \
    git \
    make \
    gcc

WORKDIR /opt

RUN git clone https://github.com/lightninglabs/lndmon.git

WORKDIR /opt/lndmon/cmd/lndmon

RUN go build

FROM alpine as final

LABEL maintainer="victor@afanassieff.com"

COPY --from=builder /opt/lndmon/cmd/lndmon/lndmon /bin/

RUN chmod +x /bin/lndmon

RUN apk --no-cache add \
    busybox \
    iputils \
    su-exec \
    shadow

RUN addgroup --system lndmon
RUN adduser lndmon --system --home /lnd -G lndmon

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["lndmon"]
