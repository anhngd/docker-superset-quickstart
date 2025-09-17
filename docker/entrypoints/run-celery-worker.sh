#!/usr/bin/env bash

set -eo pipefail

# Start Celery worker
exec celery --app=superset.tasks.celery_app:app worker \
    --loglevel=info \
    --concurrency=4 \
    --hostname="worker@%h"
