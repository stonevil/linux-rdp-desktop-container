# ---
FROM localhost/rd
MAINTAINER stone
LABEL io.stone.tags="rdp, openbox, alpine, internet, media"

RUN echo "Let's build container" && \
	echo "Container architecture: $(uname -m)" & \
	apk --no-cache update && \
	apk --no-cache upgrade && \
	apk --update fix && \
	apk --no-cache add mpv ffmpeg ffmpeg-libavcodec openh264 x265 handbrake-gtk yt-dlp yt-dlp-ejs-rt-deno deno && \
		apk --no-cache add qbittorrent --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community && \

ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:UTF-8"
ENV LC_ALL="en_US.UTF-8"

# Fix for runing on macOS
ENV UID_MIN=501

ENV PUID=${PUID:-1000}
ENV PGID=${PGID:-1000}
ENV PTZ=${PTZ:-Etc/UTC}

EXPOSE 3389/tcp

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
# ENTRYPOINT ["while" "true;" "do" "sleep 60;" "done"]
