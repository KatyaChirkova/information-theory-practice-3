FROM apache/superset:latest
USER root
RUN mkdir -p /app/.venv/lib/python3.10/site-packages && \
    pip install --no-cache-dir --no-deps --target /app/.venv/lib/python3.10/site-packages sqlalchemy-trino trino tzlocal
USER superset
