# mockbook

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/lasuillard/mockbook/main.svg)](https://results.pre-commit.ci/latest/github/lasuillard/mockbook/main)
![GitHub Release](https://img.shields.io/github/v/release/lasuillard/mockbook)

Docker image for Jupyter + FastAPI to write mocks.

![Demo](/docs/demo.gif)

## ✨ Features

Basically, Mockbook is an simple [FastAPI](https://github.com/fastapi/fastapi) application with following features:

- FastAPI server with live reloading enabled (Uvicorn built-in)

- Maintain mock endpoints using [Jupyter](https://jupyter.org/) Notebook (works by importing all cells in notebooks)

## 📔 Usage

You can try this image with Docker Compose by simply checking it out and running `docker compose up --build`. For more details, please check `docker-compose.yaml` file.

To pull and run image from [Docker Hub](https://hub.docker.com/r/lasuillard/mockbook), as follow:

```bash
$ docker run --rm \
    -p 127.0.0.1:8000:8000 \
    -p 127.0.0.1:8888:8888 \
    -e JUPYTERLAB_ARGS='--NotebookApp.token=token' \
    lasuillard/mockbook:main
```

Following endpoints will be available:

- http://localhost:8000/docs for FastAPI OpenAPI documentation.

- http://localhost:8888 for Jupyter Lab web UI for browsers.
