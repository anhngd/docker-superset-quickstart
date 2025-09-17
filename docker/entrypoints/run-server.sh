#!/usr/bin/env bash

set -eo pipefail

# Initialize the database
superset db upgrade

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

# Start the web server
exec superset run -p 8088 --host=0.0.0.0 --with-threads
