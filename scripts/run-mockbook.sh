#!/bin/bash

exec uvicorn mockbook.main:app \
    --host 0.0.0.0 \
    --reload-dir /app/mockbook \
    --reload-include '*.ipynb' \
    --reload-exclude '.ipynb_checkpoints/*' \
    "$@"
