#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- "$@"
fi

# if our command is a valid Traefik subcommand, let's invoke it through Traefik instead
# (this allows for "docker run traefik version", etc)
if traefik "$1" --help | grep -s -q "help"; then
    set -- "$@"
fi

# start cron deaemon
/usr/sbin/crond -L /dev/null

# start traefik
traefik "$@"
