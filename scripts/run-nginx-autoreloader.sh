#!/bin/bash

while true; do
	inotifywatch --event modify,create,delete --timeout 5 /app/mockbook/nginx/ |
		kill -s HUP "$(cat /var/run/nginx.pid)"
done
