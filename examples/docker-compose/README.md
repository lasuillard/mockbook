# Example - Docker Compose

Example running Mockbook container via Docker Compose.

To run the service, run the following command:

```bash
$ docker compose up
```

It will take some time to pull image and run. Once service is up, following endpoints will be available (via NGINX):

- http://localhost:80/docs for FastAPI OpenAPI documentation.

- http://localhost:80/jupyter for Jupyter Lab web UI for browsers. Default token is `token`.

This example makes slight changes to the default configuration to show how to add user customization.
