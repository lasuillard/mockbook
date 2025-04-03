#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Set environment variable defaults
export JUPYTERLAB_ARGS="${JUPYTERLAB_ARGS:-}"
export MOCKBOOK_ARGS="${MOCKBOOK_ARGS:-}"
export NGINX_ARGS="${NGINX_ARGS:-}"

if [ -n "$DISABLE_JUPYTERLAB" ]; then
	mv /app/supervisord/conf.d/jupyterlab.conf /app/supervisord/conf.d/jupyterlab.conf.disabled
	echo "JupyterLab has been disabled."
fi

if [ -z "$DISABLE_MOCKBOOK_AUTORELOAD" ]; then
	export MOCKBOOK_ARGS="$MOCKBOOK_ARGS --reload"
else
	echo "Mockbook auto reloading has been disabled."
fi

if [ -n "$DISABLE_NGINX" ]; then
	mv /app/supervisord/conf.d/nginx.conf /app/supervisord/conf.d/nginx.conf.disabled
	export DISABLE_NGINX_AUTORELOAD=1
	echo "NGINX has been disabled."
fi

if [ -n "$DISABLE_NGINX_AUTORELOAD" ]; then
	mv /app/supervisord/conf.d/nginx-reloader.conf /app/supervisord/conf.d/nginx-reloader.conf.disabled
	echo "NGINX reloader has been disabled."
fi

exec supervisord -c /app/supervisord/supervisord.conf
