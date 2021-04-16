#!/usr/bin/env bash

set -e

DOGECOIN_PATH=/home/dogecoin

# Setup user/group ids
if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u dogecoin)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome dogecoin
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" dogecoin
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /$DOGECOIN_PATH dogecoin
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g dogecoin)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" dogecoin
  fi
fi

if [ ! '$(stat -c %u "${DOGECOIN_PATH}")' = "$(id -u dogecoin)" ]; then
  chown -R dogecoin:dogecoin $DOGECOIN_PATH
fi

if [ "$1" = "dogecoind" ] || [ "$1" = "dogecoin-cli" ]; then
  gosu dogecoin "$@"
else 
    exec "$@" 
fi
