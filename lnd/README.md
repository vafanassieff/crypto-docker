# crypto-docker

This repository contains the various docker image that i build and use for my crypto related project.

Every images are pushed to [Docker Hub](https://hub.docker.com/u/vafanassieff) and to my [personnal](https://docker.afa.ovh/) registry as a mirror.

You can find the source code for every Dockerfile and script on the [repo](https://github.com/vafanassieff/crypto-docker) github page.

They comes with handy customisation like setting the user id or groupd id and keeping sensible data like auth crendentials in environement variable.

### Introduction

All images that i build are based on Alpine Linux and if not it will be indicated in the tags.

The different Dockerfile and script can be found in their folder, they will be one folder for each version that i build. In theses folder you will also find the documentation and example to the related dockerized software.

Whenever it's possible data is stored on a docker volume or you can bind it to your host file system.

Every image run the process as a non root user, you can also set the user id and group id who will run the image and map it to your host if needed.

### General Usage

Like the images from [LinuxServer.io](https://hub.docker.com/u/linuxserver/) every images come with user and group identifier. It can be handy if you mount the data to your host 

| Parameter | Function |
| :----: | --- |
| `-e UID=1000` | Set the UID |
| `-e GID=1000` | Set the GID |

Shell access whilst the container is running: `docker exec -it <container> /bin/sh`

In the doc you can find example `docker-compose.yml`

### LND

The lnd image usage is pretty simple :

```
docker create --name lnd \
    -p 9735:9735 \
    -e UID=1000 \
    -e GID=1000 \
    -e BITCOIND_RPCUSER=user \
    -e BITCOIND_RPCPASS=pass \
    -e BITCOIND_RPCHOST=bitcoin \
    -e BITCOIND_ZMQRAWBLOCK=tcp://bitcoin:28332 \
    -e BITCOIND_ZMQRAWTX=tcp://bitcoin:28333 \
    -v /path/to/lnd:/lnd/.lnd
    -v /path/to/lnd.conf:/lnd/.lnd/lnd.conf \
    vafanassieff/lnd

```

You can map your own `lnd.conf` file from your host system if you want to customize your lightning daemon.

Beware, if you use any env var it will overide your settings in your `lnd.conf` file.

### License

[License information](https://github.com/lightningnetwork/lnd/blob/master/LICENSE) for lnd.

[License information](https://github.com/vafanassieff/crypto-docker/blob/master/LICENSE) for this repository.
