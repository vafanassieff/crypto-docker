#!/bin/sh

set -e

LND_PATH=/lnd
LND_CONF_PATH=$LND_PATH/.lnd/lnd.conf

# Setup user/group ids
if [ ! -z "${UID}" ]; then
  if [ ! "$(id -u lnd)" -eq "${UID}" ]; then
    
    if [ ! "${UID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome lnd
    fi
    
    # Change the UID
    usermod -o -u "${UID}" lnd
    
    # Cleanup the temp home dir
    if [ ! "${UID}" -eq 0 ]; then
      usermod -d /lnd lnd
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${GID}" ]; then
  if [ ! "$(id -g lnd)" -eq "${GID}" ]; then
    groupmod -o -g "${GID}" lnd
  fi
fi

if [ ! '$(stat -c %u "${LND_PATH}")' = "$(id -u lnd)" ]; then
  chown -R lnd:lnd $LND_PATH
fi

if [ "$1" = "lnd" ] || [ "$1" = "lnd-cli" ] || [ "$1" = "lnd-tx" ]; then

  edit_conf () {
    grep -q "^$1=" $LND_CONF_PATH && \
    sed -i "s/^$1=.*/$1=$2/" $LND_CONF_PATH \
    || echo "$1=$2" >> $LND_CONF_PATH
  }

  # Configuring lnd may add more option later ...
  if [ ! -f "$LND_CONF_PATH" ]; then
    echo "$LND_CONF_PATH does not exist, creating it ..."
    touch $LND_CONF_PATH
    echo -e "bitcoin.active=1\nbitcoin.mainnet=1\nbitcoin.node=bitcoind" > $LND_CONF_PATH
  fi

  # Configuring lnd may add more option later ...
  if [ ! -z "${BITCOIND_RPCUSER}" ] && [ -f "$LND_CONF_PATH" ]; then
    edit_conf "bitcoind.rpcuser" ${BITCOIND_RPCUSER}
  fi

  if [ ! -z "${BITCOIND_RPCPASS}" ] && [ -f "$LND_CONF_PATH" ]; then
    edit_conf "bitcoind.rpcpass" ${BITCOIND_RPCPASS}
  fi

  if [ ! -z "${BITCOIND_RPCHOST}" ] && [ -f "$LND_CONF_PATH" ]; then
    edit_conf "bitcoind.rpchost" ${BITCOIND_RPCHOST}
  fi

  if [ ! -z "${BITCOIND_ZMQRAWBLOCK}" ] && [ -f "$LND_CONF_PATH" ]; then
    edit_conf "bitcoind.zmqpubrawblock" ${BITCOIND_ZMQRAWBLOCK}
  fi

  if [ ! -z "${BITCOIND_ZMQRAWTX}" ] && [ -f "$LND_CONF_PATH" ]; then
    edit_conf "bitcoind.zmqpubrawtx" ${BITCOIND_ZMQRAWTX}
  fi

  echo "Running $1"
  exec su-exec lnd "$@"
fi

echo "Executing $@"
exec "$@"
