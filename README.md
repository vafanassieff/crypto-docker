# crypto-docker

This repository contains the various docker image that i build and use for my crypto related project.

Every images are pushed to [Docker Hub](https://hub.docker.com/u/vafanassieff) and to my [personnal](https://docker.afa.ovh/) registry as a mirror.

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

### Bitcoin

The bitcoin image usage is pretty simple :

```
docker create --name bitcoind \
    -p 8332:8332 \
    -p 8333:8333 \
    -e UID=1000 \
    -e GID=1000 \
    -e BITCOIN_RPC_AUTH=user:salt$password_hmac \
    -v /path/to/bitcoin:/bitcoin/.bitcoin
    -v /path/to/bitcoin.conf:/bitcoin/.bitcoin/bitcoin.conf \
    vafanassieff/bitcoin

```

You can map your own `bitcoin.conf` file from your host system if you want to customize your container, like adding `txindex=1` or using texter etc ...

If you use the `BITCOIN_RPC_AUTH` variable it will replace the `rpcauth=` line in your `bitcoin.conf` file if it is not already set.
This is highly recomended to generate the credentials using [bitcoin core auth.py script](https://github.com/bitcoin/bitcoin/blob/master/share/rpcauth/rpcauth.py).

### License

[License information](https://github.com/bitcoin/bitcoin/blob/master/COPYING) for bitcoin.

[License information](https://github.com/vafanassieff/crypto-docker/blob/master/LICENSE) for this repository.
