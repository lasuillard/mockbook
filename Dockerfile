FROM python:3.13-slim-bookworm

RUN apt-get update && apt-get install -y \
    curl \
    nginx \
    supervisor \
    inotify-tools \
    && rm -rf /var/lib/apt/lists/*

# Remove NGINX welcome page
RUN rm -rf /etc/nginx/sites-enabled/default

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install deps
ENV UV_SYSTEM_PYTHON=1

COPY pyproject.toml uv.lock ./
RUN uv pip install --no-cache --requirement pyproject.toml
COPY ./mockbook /app/mockbook
RUN uv pip install --no-cache --editable .

COPY . .

ENTRYPOINT ["/app/docker-entrypoint.sh"]

EXPOSE 80 8000 8888
