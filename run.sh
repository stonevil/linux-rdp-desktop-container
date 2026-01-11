#!/usr/bin/env sh

echo "Remove conatiner"
limactl shell podman-amd64 podman rm -f rdek

echo "Run container"
# -v ./config:/config
limactl shell podman-amd64 podman run -d --shm-size="1gb" --memory="4gb" --name="rdek" -p 3389:3389 -e PUID=$UID -e PGID=$GID localhost/rdek

echo "Print auto generated password"
limactl shell podman-amd64 podman exec -it rdek bash -c 'cat /remote'
