FROM golang:1.14-alpine as builder

LABEL maintainer="victor@afanassieff.com"

RUN apk add --no-cache git gcc musl-dev

RUN apk add --no-cache --update alpine-sdk \
    git \
    make \
    bash \
    gcc

WORKDIR /opt

RUN git clone https://github.com/lightninglabs/lndmon.git && \
    cd lndmon && \
    git checkout tags/v0.2.0

ENV GO111MODULE on

RUN cd lndmon/cmd/lndmon && go build

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
RUN adduser lndmon --system --home /lndmon -G lndmon

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["lndmon"]
