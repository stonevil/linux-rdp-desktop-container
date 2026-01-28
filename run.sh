#!/usr/bin/env bash

if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; fi

echo "Remove conatiner"
podman rm -f rdek

echo "Run container"
# add this option to mount local directory us home directory inside container to preserve configs: -v ./config:/config
podman run -d --shm-size="1gb" --memory="4gb" --name="rdek" -p 3389:3389 -e PUID=$UID -e PGID=$GID localhost/rdek

echo "Print auto generated password"
podman exec -it rdek bash -c 'cat /remote'
