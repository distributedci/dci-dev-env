#!/bin/sh
set -e

HBA_FILE="${PGDATA}/pg_hba.conf"

if [ -f "${HBA_FILE}" ]; then
  echo "=> updating pg_hba.conf: require TLS & SCRAM-SHA-256"

  sed -i -E 's/^host[[:space:]]+(.*)[[:space:]]+md5$/hostssl \1 scram-sha-256/' "${HBA_FILE}"
fi
