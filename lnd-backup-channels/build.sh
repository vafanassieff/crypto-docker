#!/usr/bin/env bash

set -e

cd docker 

# For docker hub ...
IMAGE_NAME="vafanassieff/lnd-channels-backup"
docker build -t $IMAGE_NAME .
echo "$IMAGE_NAME built √"

if [ "$1" == "registry" ]; then
    docker push $IMAGE_NAME
    echo "$IMAGE_NAME pushed √"
    if [ "$2" == "latest" ]; then
        echo "Add the latest tag to the image"
        docker tag  $IMAGE_NAME $IMAGE_NAME:latest
        docker push $IMAGE_NAME:latest
        echo "$IMAGE_NAME:latest pushed √"
    fi
fi

# For my personal registry ...
IMAGE_NAME="registry.afa.ovh/lnd-channels-backup"
docker build -t $IMAGE_NAME .
if [ "$1" == "registry" ]; then
    docker push $IMAGE_NAME
    echo "$IMAGE_NAME pushed √"
    if [ "$2" == "latest" ]; then
        echo "Add the latest tag to the image"
        docker tag  $IMAGE_NAME $IMAGE_NAME:latest
        docker push $IMAGE_NAME:latest
        echo "$IMAGE_NAME:latest pushed √"
    fi
fi
