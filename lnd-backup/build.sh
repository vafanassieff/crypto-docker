#!/usr/bin/env bash

set -e

NAME="lnd-backup-channels"

if [ "$1" == "registry" ]; then
    IMAGE="vafanassieff/$NAME"
    echo "Building $IMAGE"
    docker build -t $IMAGE:latest .
    docker login registry.gitlab.com
    docker push $IMAGE:latest
    echo "$IMAGE:latest has been built √"

    # For my personal registry ...
    IMAGE="registry.afa.ovh/$NAME"
    docker build -t $IMAGE_NAME:$VERSION .
    echo "Building $IMAGE"
    docker build -t $IMAGE:latest .
    docker login registry.gitlab.com
    docker push $IMAGE:latest
    echo "$IMAGE:latest has been built √"
else
    echo "Building $IMAGE:dev"
    docker build -t $IMAGE:dev .
    echo "$IMAGE:dev has been built √"
fi
