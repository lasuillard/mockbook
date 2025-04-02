#!/bin/bash

# Wait for the NGINX service to start
sleep 5

while true; do
	inotifywait --quiet --event modify,create,delete --recursive /app/mockbook/nginx/ |
		while read -r CHANGE; do
			kill -s HUP "$(cat /var/run/nginx.pid)"
			echo "Reloaded NGINX configuration due to change: $CHANGE"
		done
done
