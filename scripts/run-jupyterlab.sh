#!/bin/bash

exec jupyter lab \
	--allow-root \
	--ip 0.0.0.0 \
	--ServerApp.root_dir /app/mockbook \
	--config /app/jupyterlab/config.py \
	"$@"
