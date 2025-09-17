#!/usr/bin/env bash

set -eo pipefail

echo "Running Superset bootstrap..."

# Wait for database to be ready
until superset db upgrade; do
  echo "Database not ready, waiting..."
  sleep 2
done

# Create an admin user if it doesn't exist
if ! superset fab list-users | grep -q admin; then
    superset fab create-admin \
        --username admin \
        --firstname Superset \
        --lastname Admin \
        --email admin@superset.com \
        --password admin
fi

# Initialize Superset
superset init

echo "Bootstrap completed successfully!"
