#! /bin/sh

set -e -o pipefail

upload () {
    if [ ! -z "$AWS_SECRET_ACCESS_KEY" ] && [ ! -z "$AWS_ACCESS_KEY_ID" ] && [ ! -z "$AWS_S3_BUCKET" ]; then
        aws s3 cp ${BACKUP_DIR}/channel.backup s3://${AWS_S3_BUCKET}/${AWS_S3_BUCKET_PATH}
    fi

    if [ ! -z "$DROPBOX_ACCESS_TOKEN" ] && [ ! -z "$DROPBOX_PATH" ]; then
        echo "Pushing backup to dropbox ..."
        curl -X POST https://content.dropboxapi.com/2/files/upload \
            --header "Authorization: Bearer ${DROPBOX_ACCESS_TOKEN}" \
            --header "Dropbox-API-Arg: {\"path\": \"${DROPBOX_PATH}/channel.backup\", \"mode\": \"overwrite\"}" \
            --header "Content-Type: application/octet-stream" \
            --data-binary @${BACKUP_DIR}/channel.backup
    fi
}

echo "Doing first backup ..."
cp ${LND_CHANNEL_BACKUP_DIR}/channel.backup ${BACKUP_DIR}/channel.backup
upload

while true; do
    inotifywait ${LND_CHANNEL_BACKUP_DIR}/channel.backup
    cp ${LND_CHANNEL_BACKUP_DIR}/channel.backup ${BACKUP_DIR}/channel.backup
    upload
done
