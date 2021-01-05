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

if [ "$1" = "lnd" ]; then
  if [ -f "$LND_CONF_PATH" ]; then

  edit_conf () {
    if grep -q "^$1=" $LND_CONF_PATH;then
      VAR=$(echo "$2" | sed 's/[&=\|]/\&/g')
      sed 's/^$1=.*/$1=${VAR}/' $LND_CONF_PATH > /tmp.conf
      cat /tmp.conf > $LND_CONF_PATH
      rm /tmp.conf
    else
      echo "$1=$2" >> $LND_CONF_PATH
    fi
  }

    if ! grep -q "\[Bitcoind\]" $LND_CONF_PATH;then
      echo -e "\n[Bitcoind]" >> $LND_CONF_PATH
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

    exec su-exec lnd lnd
  else
    cmd="$*"
    if [ ! -z "${BITCOIND_RPCPASS}" ]; then
      echo "Replacing bitcoind rpc password"
      cmd=${cmd/BITCOIND_RPCPASS/$BITCOIND_RPCPASS}
    fi

    exec su-exec lnd $cmd
  fi
elif [ "$1" = "lnd-cli" ] || [ "$1" = "lnd-tx" ]; then
  exec su-exec lnd "$@"
else
  echo "Executing $@"
  exec "$@"
fi
