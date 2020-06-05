#!/bin/sh

set -e

TOR_CONF_PATH=/etc/tor/torrc

edit_conf () {
    if grep -q "^$1 $2" $TOR_CONF_PATH;then
        return
    fi
    if grep -q "^$1" $TOR_CONF_PATH;then
        VAR=$(echo "$2" | sed 's/[&=\|]/\&/g')
        sed "s/^$1.*/$1 $VAR/" $TOR_CONF_PATH > /tmp.conf
        cat /tmp.conf > $TOR_CONF_PATH && rm /tmp.conf
    else
        echo "$1 $2" >> $TOR_CONF_PATH
    fi
}

if [ ! -z "$UID" ]; then
    usermod -u $UID tor
fi

if [ ! -z "$GID" ]; then
    groupmod -g $GID tor
fi

# Configuring tor may add more option later ...
if [ ! -z "$SOCKS_PORT" ] && [ -f "$TOR_CONF_PATH" ]; then
    edit_conf "SOCKSPort" $SOCKS_PORT
fi

if [ ! -z "$SOCKS_POLICY_ACCEPT" ] && [ -f "$TOR_CONF_PATH" ]; then
    edit_conf "SOCKSPolicy accept" $SOCKS_POLICY_ACCEPT
fi

if [ ! -z "$CONTROL_PORT" ] && [ -f "$TOR_CONF_PATH" ]; then
    edit_conf "ControlPort" $CONTROL_PORT
fi

if [ ! -z "$COOKIE_AUTH" ] && [ -f "$TOR_CONF_PATH" ]; then
    edit_conf "CookieAuthentication" "1"
fi

if [ ! -z "$PASSWORD" ] && [ -f "$TOR_CONF_PATH" ]; then
    HASHEDPASSWORD=$(exec su-exec tor tor --hash-password ${PASSORD}})
    edit_conf "HashedControlPassword" $HASHEDPASSWORD
else
    LINE=$(cat $TOR_CONF_PATH | grep -n "HashedControlPassword" | cut -c1)
    sed "${LINE}d" $TOR_CONF_PATH > /tmp.conf
    cat /tmp.conf > $TOR_CONF_PATH && rm /tmp.conf
fi

cat $TOR_CONF_PATH

if [ $1 = "tor" ];then
    su-exec tor tor --verify-config
    exec su-exec tor "$@"
else
    echo "Executing $@"
    exec "$@"
fi
