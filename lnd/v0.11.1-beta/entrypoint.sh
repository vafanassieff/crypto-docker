#!/bin/sh

set -e

if [ ! -z "${PUID}" ]; then
  if [ ! "$(id -u lnd)" -eq "${PUID}" ]; then
    
    if [ ! "${PUID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome lnd
    fi
    
    # Change the UID
    usermod -o -u "${PUID}" lnd
    
    # Cleanup the temp home dir
    if [ ! "${PUID}" -eq 0 ]; then
      usermod -d /lnd lnd
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${PGID}" ]; then
  if [ ! "$(id -g lnd)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" lnd
  fi
fi

if [ ! '$(stat -c %u "${LND_PATH}")' = "$(id -u lnd)" ]; then
  chown -R lnd:lnd $LND_PATH
fi


if [ "$1" = "lnd" ]; then
  cmd="$*"
  if [ ! -z "${BITCOIND_RPCPASS}" ]; then
    cmd=${cmd/BITCOIND_RPCPASS/$BITCOIND_RPCPASS}
  fi
  if [ ! -z "${BITCOIND_RPCPASS}" ]; then
    cmd=${cmd/TOR_PASSWORD/$TOR_PASSWORD}
  fi
  exec su-exec lnd $cmd
elif [ "$1" = "lnd-cli" ] || [ "$1" = "lnd-tx" ]; then
  exec su-exec lnd "$@"
else
  exec "$@"
fi
