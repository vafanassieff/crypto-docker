#!/usr/bin/env bash

set -e

TOR_CONF_PATH=/etc/tor/torrc

if [ ! -z "$UID" ]; then
    usermod -u $UID tor
fi

if [ ! -z "$GID" ]; then
    groupmod -g $GID tor
fi

rm -f $TOR_CONF_PATH

if [ ! -z "$PASSWORD" ]; then
    echo HashedControlPassword $(tor --hash-password "${PASSWORD}" | tail -n 1) >> /etc/tor/torrc
fi

for tor_options in $(printenv | grep TOR_)
do
    options="${tor_options:4}"
    readarray -d = -t options <<< "$options"
    option=${options[0]}
    value=${options[1]}
    echo $option $value >> $TOR_CONF_PATH
done

if [ $1 = "tor" ];then
    su-exec tor tor -f $TOR_CONF_PATH --verify-config
    exec su-exec tor tor -f $TOR_CONF_PATH
else
    exec "$@"
fi
