#!/bin/sh

set -e

if [ "$1" = "lndmon" ]; then
  exec su-exec lndmon "$@"
else
  exec "$@"
fi
