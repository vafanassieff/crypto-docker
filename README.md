# crypto-docker

This repository contains the various docker image that i build and use for my crypto related project.

Every images are pushed to [Docker Hub](https://hub.docker.com/u/vafanassieff) and to my [personnal](https://docker.afa.ovh/) registry as a mirror.

They comes with handy customisation like setting the user id or groupd id and keeping sensible data like auth crendentials in environement variable.

## Introduction

All images that i build are based on Alpine Linux and if not it will be indicated in the tags.

The different Dockerfile and script can be found in their folder, they will be one folder for each version that i build. In theses folder you will also find the documentation and example to the related dockerized software.

Whenever it's possible data is stored on a docker volume or you can bind it to your host file system.

Every image run the process as a non root user, you can also set the user id and group id who will run the image and map it to your host if needed.

## General Usage

Will be rewritten soon see example

## Bitcoin

Will be rewritten soon see example

## LND

Will be rewritten soon see example

## License

[License information](https://github.com/bitcoin/bitcoin/blob/master/COPYING) for bitcoin.

[License information](https://github.com/vafanassieff/crypto-docker/blob/master/LICENSE) for this repository.
