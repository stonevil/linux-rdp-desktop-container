#!/usr/bin/env bash
# vim:ft=bash

trap "exit" INT

media_url="$@"

if [[ -z "${media_url}" ]]; then
	read -p "Please provide URL: " media_url
fi

yt_user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.2 Safari/605.1.15"

cd ~/Downloads/ || exit 1

yt_title=$(yt-dlp -4 --skip-download --get-title --no-warnings "$media_url" | sed 2d)
printf "%s\n" "Download media: $yt_title"

media_number=$(yt-dlp -4 --no-warnings --quiet --user-agent "$yt_user_agent" --list-formats "$media_url" | fzf --header 'Select or type prefered video/audio ID from the left column' --header-lines=2 | awk '{print $1}')

if [[ -n $media_number ]]; then
	yt-dlp -4 --js-runtimes deno --no-warnings --user-agent "$yt_user_agent" --format "$media_number" --embed-metadata --embed-thumbnail --recode-video mp4 --audio-format m4a --merge-output-format mp4 "$media_url"
else
	echo "No media format number provided."
	exit 1
fi
