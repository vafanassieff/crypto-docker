#!/usr/bin/env bash

set -e

VERSION=$1

if [ ! -z "$VERSION" ]; then
    echo "Building lndemon using version $VERSION"
    cd ./$VERSION

    # For docker hub ...
    IMAGE_NAME="vafanassieff/lndemon"
    docker build -t $IMAGE_NAME:$VERSION .
    echo "$IMAGE_NAME:$VERSION built √"

    if [ "$2" == "registry" ]; then
        docker push $IMAGE_NAME:$VERSION
        echo "$IMAGE_NAME:$VERSION pushed √"
        if [ "$3" == "latest" ]; then
            echo "Add the latest tag to the image"
            docker tag  $IMAGE_NAME:$VERSION $IMAGE_NAME:latest
            docker push $IMAGE_NAME:latest
            echo "$IMAGE_NAME:latest pushed √"
        fi
    fi

    # For my personal registry ...
    IMAGE_NAME="registry.afa.ovh/lndemon"
    docker build -t $IMAGE_NAME:$VERSION .
    if [ "$2" == "registry" ]; then
        docker push $IMAGE_NAME:$VERSION
        echo "$IMAGE_NAME:$VERSION pushed √"
        if [ "$3" == "latest" ]; then
            echo "Add the latest tag to the image"
            docker tag  $IMAGE_NAME:$VERSION $IMAGE_NAME:latest
            docker push $IMAGE_NAME:latest
            echo "$IMAGE_NAME:latest pushed √"
        fi
    fi
else
    echo "Need first arg as version number"
fi
