#!/bin/bash
# Starts up MariaDB within the container.

# Stop on error
#set -xv

NEST_DATA_DIR=/data

if [[ -e /firstrun ]]; then
  . /scripts/first_run.sh
else
  . /scripts/normal_run.sh
fi

wait_for_mysql_and_run_post_start_action() {
  # Wait for mysql to finish starting up first.
  until [ -f /var/run/mysqld/mysqld.sock ]
  do
      echo waiting for mysql ...
      sleep 5
  done

  post_start_action
}

pre_start_action

wait_for_mysql_and_run_post_start_action &

# Start MariaDB
echo "Starting MariaDB..."
exec /usr/bin/mysqld_safe
