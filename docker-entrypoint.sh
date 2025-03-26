#!/usr/bin/env bash

# Set environment variable defaults
export JUPYTERLAB_ARGS="${JUPYTERLAB_ARGS:-}"

if [ -n "$DISABLE_JUPYTERLAB" ]; then
	mv /app/conf.d/jupyterlab.conf /app/conf.d/jupyterlab.conf.disabled
	echo "JupyterLab has been disabled."
fi

exec supervisord -c /app/supervisord.conf
