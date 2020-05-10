FROM alpine:3.11

ENV LND_CHANNEL_BACKUP_DIR="/lnd" \
    BACKUP_DIR="/backups" \
    AWS_SECRET_ACCESS_KEY="" \
    AWS_ACCESS_KEY_ID="" \
    AWS_S3_BUCKET="" \ 
    AWS_S3_BUCKET_PATH="" \
    DROPBOX_ACCESS_TOKEN="" \
    DROPBOX_PATH=""

RUN apk --no-cache add python tini inotify-tools curl

RUN apk --no-cache add --virtual build-dependencies py-pip && \
    pip --no-cache-dir install awscli && \
    apk del build-dependencies

COPY backup.sh /backup.sh

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/backups"]

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

CMD ["/backup.sh"]
