# mockbook

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/lasuillard/mockbook/main.svg)](https://results.pre-commit.ci/latest/github/lasuillard/mockbook/main)
![GitHub Release](https://img.shields.io/github/v/release/lasuillard/mockbook)

Docker image for Jupyter + FastAPI to write mocks.

![Demo](/docs/demo.gif)

## ✨ Features

Mockbook is an simple [FastAPI](https://github.com/fastapi/fastapi) application with following features:

- Write mock endpoints with [FastAPI](https://fastapi.tiangolo.com/) server with live reloading enabled

- Use [Jupyter](https://jupyter.org/) Notebook to maintain mock endpoints

- Pre-configured [NGINX](https://nginx.org/) reverse proxy with reloader triggered on configuration file changes for full mocking flexibility

- Pre-installed libraries for writing mocks: [factory-boy](https://github.com/FactoryBoy/factory_boy), [Faker](https://github.com/joke2k/faker)

## 📔 Usage

To pull and run image from [Docker Hub](https://hub.docker.com/r/lasuillard/mockbook), as follow:

```bash
$ docker run --rm \
    -p 127.0.0.1:80:80 \
    -e JUPYTERLAB_ARGS='--NotebookApp.token=token' \
    lasuillard/mockbook:main
```

Following endpoints will be available (via NGINX):

- http://localhost:80/docs for FastAPI OpenAPI documentation.

- http://localhost:80/jupyter for Jupyter Lab web UI for browsers.

Also, following environment variables supported:

| Key                            | Description                                                                                                                                               |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `MOCKBOOK_ARGS`                | Extra arguments for Mockbook (**uvicorn**)                                                                                                                |
| `MOCKBOOK_AUTORELOAD_DISABLED` | Disable auto reloading (`--reload` argument of **uvicorn**). <br/>May useful for certain environments (such as testing) where reloading is not desirable. |
| `NGINX_ARGS`                   | Extra arguments to pass to NGINX.                                                                                                                         |
| `JUPYTERLAB_ARGS`              | Extra arguments for JupyterLab.                                                                                                                           |
| `JUPYTERLAB_DISABLED`          | Disable JupyterLab service. <br/>May useful for certain environments (such as testing) where notebook is unnecessary.                                     |
| `NGINX_DISABLED`               | Disable NGINX service.                                                                                                                                    |
| `NGINX_RELOADER_DISABLED`      | Disable NGINX reloader.                                                                                                                                   |

Please check [`docker-compose.yaml`](/docker-compose.yaml) file for more detailed example.
