#!/usr/bin/env bash

# Create the user account
if ! id remote >/dev/null 2>&1; then
	if [[ -f /etc/os-release ]]; then
		. /etc/os-release
		OS_ID=$ID

		if [[ "$OS_ID" == "fedora" ]]; then
			groupadd --force --gid ${PGID:-1000} remote
			useradd --shell /bin/bash --uid ${PUID:-1000} --gid ${PGID:-1000} --groups wheel --password "$(openssl passwd ${PASS:-remote})" --create-home --home-dir /config remote
		elif [[ "$OS_ID" == "alpine" ]]; then
			addgroup -g ${PGID:-1000} remote
			adduser -s /bin/bash -u ${PUID:-1000} -g ${PGID:-1000} -G wheel -h /config remote
			echo "remote:${PASS:-remote}" | /usr/sbin/chpasswd
			echo "remote ALL=(ALL) ALL" >> /etc/sudoers
			echo "Set disable_coredump false" >> /etc/sudoers.conf
			xrdp-keygen xrdp auto
		else
			echo "Unsupported Linux distribution: $OS_ID"
		fi
	else
		echo "Could not determine Linux distribution"
	fi

	echo "remote	ALL = (ALL) NOPASSWD:	ALL" > /etc/sudoers.d/remote

	su - remote -c "echo xfce4-session > ~/.Xclients"
	su - remote -c "chmod +x ~/.Xclients"

	su - remote -c "mkdir -p ~/.config/gtk-{2.0,3.0,4.0}"

	for i in "2.0" "3.0" "4.0"; do
		su - remote -c "printf '[Settings]\ngtk-application-prefer-dark-theme=1\n' > ~/.config/gtk-$i/settings.ini"
	done
fi

# Remove existing sesman/xrdp PID files to prevent rdp sessions hanging on container restart
[ ! -f /var/run/xrdp/xrdp-sesman.pid ] || rm -f /var/run/xrdp/xrdp-sesman.pid
[ ! -f /var/run/xrdp/xrdp.pid ] || rm -f /var/run/xrdp/xrdp.pid

# Start xrdp sesman service
/usr/sbin/xrdp-sesman

# Run xrdp in foreground if no commands specified
if [ -z "$1" ]; then
	/usr/sbin/xrdp --nodaemon
else
	/usr/sbin/xrdp
	exec "$@"
fi
