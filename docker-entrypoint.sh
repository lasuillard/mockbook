#!/usr/bin/env bash

# Set environment variable defaults
export JUPYTERLAB_ARGS="${JUPYTERLAB_ARGS:-}"
export MOCKBOOK_ARGS="${MOCKBOOK_ARGS:-}"

if [ -n "$DISABLE_JUPYTERLAB" ]; then
	mv /app/conf.d/jupyterlab.conf /app/conf.d/jupyterlab.conf.disabled
	echo "JupyterLab has been disabled."
fi

if [ -z "$DISABLE_MOCKBOOK_AUTORELOAD" ]; then
	export MOCKBOOK_ARGS="$MOCKBOOK_ARGS --reload"
	echo "Mockbook auto reloading has been enabled."
fi

exec supervisord -c /app/supervisord/supervisord.conf
