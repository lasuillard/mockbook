#!/bin/bash

# TODO(lasuillard): Auto reloading for configuration changes
nginx -g 'daemon off;' -c /app/mockbook/nginx/main.conf
