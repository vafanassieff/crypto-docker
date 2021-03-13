FROM alpine

ENV LND_CHANNEL_BACKUP_DIR="/lnd"
ENV BACKUP_DIR="/backups"
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_S3_BUCKET=""
ENV AWS_S3_BUCKET_PATH=""
ENV DROPBOX_ACCESS_TOKEN=""
ENV DROPBOX_PATH=""

RUN apk --no-cache add tini inotify-tools curl

RUN apk add --no-cache \
    python3 \
    py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
    awscli \
    && rm -rf /var/cache/apk/*

COPY backup.sh /backup.sh

VOLUME ["/backups"]

CMD ["/backup.sh"]
