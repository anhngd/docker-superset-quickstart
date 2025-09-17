#!/usr/bin/env bash

set -eo pipefail

# Remove any existing celerybeat-schedule file to avoid issues
rm -f /tmp/celerybeat-schedule

# Start Celery Beat scheduler
exec celery --app=superset.tasks.celery_app:app beat \
    --loglevel=info \
    --schedule=/tmp/celerybeat-schedule
