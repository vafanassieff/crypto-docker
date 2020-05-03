#!/bin/sh

set -e

D_LNDMON_PATH=${LNDMON_PATH:-/lndmon}
D_LISTEN_ADDRESS=${LISTEN_ADDRESS:-0.0.0.0:9092}
D_LND_NETWORK=${LND_NETWORK:-testnet}
D_LND_HOST=${LND_HOST:-lnd-testnet}
D_MACAROON_DIR=${MACAROON_DIR:-/lndmon/lnd/macaroons}
D_TLS_CERT_PATH=${TLS_CERT_PATH:-/lndmon/lnd/tls.cert}

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
  chown -R lndmon:lndmon $D_LNDMON_PATH
fi


if [ "$1" = "lndmon" ]; then
  OPTIONS="--prometheus.listenaddr=$D_LISTEN_ADDRESS\
  --lnd.network=$D_LND_NETWORK --lnd.host=$D_LND_HOST\
  --lnd.macaroondir=$D_MACAROON_DIR --lnd.tlspath=$D_TLS_CERT_PATH"
  echo "starting lndmon with options $OPTIONS"

  exec su-exec lndmon "$@" $OPTIONS
fi

echo "Executing $@"
exec "$@"
