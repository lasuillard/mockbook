FROM python:3.13-slim-bookworm

RUN apt-get update && apt-get install -y \
    supervisor \
    curl \
    && apt-get clean

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install deps
ENV UV_SYSTEM_PYTHON=1 \
    PYTHONPATH="/app"

COPY pyproject.toml uv.lock ./
RUN uv pip install -r pyproject.toml
COPY ./mockbook /app/mockbook
RUN uv pip install -e .

COPY ./supervisord/conf.d/* /app/conf.d/
COPY ./supervisord/supervisord.conf /app/supervisord.conf
COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
