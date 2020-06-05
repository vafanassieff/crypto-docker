#!/bin/sh

set -e

BITCOIN_PATH=/bitcoin
BITCOIN_CONF_PATH=$BITCOIN_PATH/.bitcoin/bitcoin.conf

# Setup user/group ids
if [ ! -z "${UID}" ]; then
  if [ ! "$(id -u bitcoin)" -eq "${UID}" ]; then
    
    if [ ! "${UID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome bitcoin
    fi
    
    # Change the UID
    usermod -o -u "${UID}" bitcoin
    
    # Cleanup the temp home dir
    if [ ! "${UID}" -eq 0 ]; then
      usermod -d /$BITCOIN_PATH bitcoin
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${GID}" ]; then
  if [ ! "$(id -g bitcoin)" -eq "${GID}" ]; then
    groupmod -o -g "${GID}" bitcoin
  fi
fi

if [ ! '$(stat -c %u "${BITCOIN_PATH}")' = "$(id -u bitcoin)" ]; then
  chown -R bitcoin:bitcoin $BITCOIN_PATH
fi

if [ "$1" = "bitcoind" ]; then
  # Configuring bitcoin may add more option later ...
  if [ ! -f "$BITCOIN_CONF_PATH" ]; then
    echo "$BITCOIN_CONF_PATH does not exist, creating it ..."
    touch $BITCOIN_CONF_PATH
    echo -e "server=1" > $BITCOIN_CONF_PATH
  fi

  if [ ! -z "${BITCOIN_RPC_AUTH}" ]; then
    echo "Setting the rpc auth ..."
    if grep -q "^rpcauth=" $BITCOIN_CONF_PATH;then
      sed "s/^rpcauth=.*/rpcauth=${BITCOIN_RPC_AUTH}/" $BITCOIN_CONF_PATH > /tmp.conf
      cat /tmp.conf > $BITCOIN_CONF_PATH
      rm /tmp.conf
    else
      echo "rpcauth=${BITCOIN_RPC_AUTH}" >> $BITCOIN_CONF_PATH
    fi
  fi

  exec su-exec bitcoin "$@" 
fi

if [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  exec su-exec bitcoin "$@"
fi

exec "$@"
