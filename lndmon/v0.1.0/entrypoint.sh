#!/bin/sh

set -e

LNDMON_PATH="/lndmon"
LISTEN_ADDRESS="0.0.0.0:9092"
LND_NETWORK="testnet"
LND_HOST="lnd-testnet"
MACAROON_DIR="/lndmon/lnd"
TLS_CERT_PATH="/lndmon/lnd/tls.cert"

# Setup user/group ids
if [ ! -z "${UID}" ]; then
  if [ ! "$(id -u lndmon)" -eq "${UID}" ]; then
    
    if [ ! "${UID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome lndmon
    fi
    
    # Change the UID
    usermod -o -u "${UID}" lndmon
    
    # Cleanup the temp home dir
    if [ ! "${UID}" -eq 0 ]; then
      usermod -d /lndmon lndmon
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${GID}" ]; then
  if [ ! "$(id -g lndmon)" -eq "${GID}" ]; then
    groupmod -o -g "${GID}" lndmon
  fi
fi

if [ ! '$(stat -c %u "${LNDMON_PATH}")' = "$(id -u lndmon)" ]; then
  chown -R lndmon:lndmon $LNDMON_PATH
fi


if [ "$1" = "lndmon" ]; then
  exec su-exec lndmon "$@" --prometheus.listenaddr=$LISTEN_ADDRESS \
  --lnd.network=$LND_NETWORK --lnd.host=$LND_HOST \
  --lnd.macaroondir=$MACAROON_DIR --lnd.tlspath=$TLS_CERT_PATH
fi

echo "Executing $@"
exec "$@"
