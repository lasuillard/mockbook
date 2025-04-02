#!/bin/bash

exec nginx \
	-g 'daemon off;' \
	-c /app/mockbook/nginx/main.conf \
	"$@"
