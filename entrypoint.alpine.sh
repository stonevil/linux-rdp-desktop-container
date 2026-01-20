#!/usr/bin/env bash

if ! id remote >/dev/null 2>&1; then
	remote_p=$(pwgen 12 1)
	echo ${remote_p} > /remote
	echo "password:" ${remote_p} >&2

	adduser -s /bin/bash -u ${PUID:-1000} -h /config remote
	addgroup remote wheel
	echo "remote:${remote_p:-remote}" | /usr/sbin/chpasswd
	xrdp-keygen xrdp auto

	su - remote -c "mkdir -p ~/Desktop ~/Documents ~/Downloads ~/Videos ~/Pictures ~/Music"

	if command -v openbox >/dev/null 2>&1; then
		su - remote -c "echo -e 'xrandr -s 1024x800\nexec openbox-session;' > ~/.xinitrc"
	else
		if command -v oxwm >/dev/null 2>&1; then
			su - remote -c "echo -e 'xrandr -s 1024x800\nexec oxwm;' > ~/.xinitrc"
		fi
	fi
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
