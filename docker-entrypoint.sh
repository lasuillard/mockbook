#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Mockbook core
# ----------------------------------------------------------------------------
export MOCKBOOK_ARGS="${MOCKBOOK_ARGS:-}"

if [ -z "$MOCKBOOK_AUTORELOAD_DISABLED" ]; then
	export MOCKBOOK_ARGS="$MOCKBOOK_ARGS --reload"
else
	echo "Mockbook auto reloading has been disabled."
fi

# JupyterLab
# ----------------------------------------------------------------------------
export JUPYTERLAB_ARGS="${JUPYTERLAB_ARGS:-}"

if [ -n "$JUPYTERLAB_DISABLED" ]; then
	mv /app/supervisord/conf.d/jupyterlab.conf /app/supervisord/conf.d/jupyterlab.conf.disabled
	echo "JupyterLab has been disabled."
fi

# NGINX
# ----------------------------------------------------------------------------
export NGINX_ARGS="${NGINX_ARGS:-}"

if [ -n "$NGINX_DISABLED" ]; then
	mv /app/supervisord/conf.d/nginx.conf /app/supervisord/conf.d/nginx.conf.disabled
	export NGINX_RELOADER_DISABLED=1
	echo "NGINX has been disabled."
fi

# NGINX reloader
# ----------------------------------------------------------------------------
if [ -n "$NGINX_RELOADER_DISABLED" ]; then
	mv /app/supervisord/conf.d/nginx-reloader.conf /app/supervisord/conf.d/nginx-reloader.conf.disabled
	echo "NGINX reloader has been disabled."
fi

exec supervisord -c /app/supervisord/supervisord.conf
