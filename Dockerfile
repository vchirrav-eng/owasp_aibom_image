FROM python:3.11-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONPATH=/app

COPY README.md /app/README.md
COPY pyproject.toml /app/pyproject.toml
COPY LICENSE /app/LICENSE
COPY src /app/src
COPY entrypoint.sh /app/entrypoint.sh

RUN pip install --upgrade pip \
    && pip install -e . \
    && chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
