FROM python:3.13-slim-bookworm

RUN apt-get update && apt-get install -y \
    supervisor \
    curl \
    && apt-get clean

COPY ./requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

COPY ./mockbook /app/mockbook

ENV PYTHONPATH="${PYTHONPATH}:/app"

COPY ./supervisord/conf.d/* /app/conf.d/
COPY ./supervisord/supervisord.conf /app/supervisord.conf
COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
