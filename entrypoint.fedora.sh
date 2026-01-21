#!/usr/bin/env bash

if ! id remote >/dev/null 2>&1; then
	remote_p=$(pwgen 12 1)
	echo ${remote_p} > /remote
	echo "password:" ${remote_p} >&2

	groupadd --force --gid ${PGID:-1000} remote
	useradd --shell /bin/bash --uid ${PUID:-1000} --gid ${PGID:-1000} --groups wheel --password "$(openssl passwd ${remote_p:-remote})" --create-home --home-dir /config remote
	echo "remote	ALL = (ALL) NOPASSWD:	ALL" > /etc/sudoers.d/remote

	su - remote -c "echo xfce4-session > ~/.Xclients"
	su - remote -c "chmod +x ~/.Xclients"
fi

# Remove existing sesman/xrdp PID files to prevent rdp sessions hanging on container restart
[ -f /var/run/xrdp/xrdp-sesman.pid ] && rm -f /var/run/xrdp/xrdp-sesman.pid
[ -f /var/run/xrdp/xrdp.pid ] && rm -f /var/run/xrdp/xrdp.pid

# Start xrdp sesman service
/usr/sbin/xrdp-sesman

# Run xrdp in foreground if no commands specified
if [ -z "$1" ]; then
	/usr/sbin/xrdp --nodaemon
else
	/usr/sbin/xrdp
	exec "$@"
fi
