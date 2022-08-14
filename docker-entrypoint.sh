#!/bin/bash

set -e

bundle install

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Run the command.
exec "$@"