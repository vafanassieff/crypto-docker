#!/bin/sh

set -e

LIT_PATH=/lit
LIT_CONF_PATH=$LIT_PATH/.lit/lit.conf

# Setup user/group ids
if [ ! -z "${UID}" ]; then
  if [ ! "$(id -u lit)" -eq "${UID}" ]; then
    
    if [ ! "${UID}" -eq 0 ]; then
      mkdir -p /tmp/temphome
      usermod -d /tmp/temphome lit
    fi
    
    # Change the UID
    usermod -o -u "${UID}" lit
    
    # Cleanup the temp home dir
    if [ ! "${UID}" -eq 0 ]; then
      usermod -d /lit lit
      rm -Rf /tmp/temphome
    fi
  fi
fi

if [ ! -z "${GID}" ]; then
  if [ ! "$(id -g lit)" -eq "${GID}" ]; then
    groupmod -o -g "${GID}" lit
  fi
fi

if [ ! '$(stat -c %u "${LIT_PATH}")' = "$(id -u lit)" ]; then
  chown -R lit:lit $LIT_PATH
fi

if [ "$1" = "litd" ] || [ "$1" = "frcli" ] || [ "$1" = "loop" ] || [ "$1" = "lncli" ]; then
  exec su-exec lnd "$@"
else
  echo "Executing $@"
  exec "$@"
fi
