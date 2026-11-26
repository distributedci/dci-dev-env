#!/bin/sh
set -e

CERT_DIR="/certs"

if [ -f "$CERT_DIR/ca.crt" ]; then
  echo "==> CA already present in $CERT_DIR."
else
  echo "==> Generate the CA and certificates with mkcert ..."
  mkdir -p "$CERT_DIR"

  export CAROOT="$CERT_DIR"

  mkcert -install

  cp "$CERT_DIR/rootCA.pem" "$CERT_DIR/ca.crt"
fi

for SERVICE_NAME in rabbitmq redis db haproxy; do
  if [ -f "$CERT_DIR/${SERVICE_NAME}.crt" ]; then
    echo "ℹ️ Certificate already exists for ${SERVICE_NAME}"
  else
    echo -n "Generating ${SERVICE_NAME} cert "
    mkcert -cert-file "$CERT_DIR/${SERVICE_NAME}.crt" \
      -key-file "$CERT_DIR/${SERVICE_NAME}.key" \
      ${SERVICE_NAME} localhost 127.0.0.1 ::1
    cat "$CERT_DIR/${SERVICE_NAME}.crt" "$CERT_DIR/${SERVICE_NAME}.key" >"$CERT_DIR/${SERVICE_NAME}.pem"
    echo "✅"
  fi
done

# All certs & keys should be readable by any rootless user
chmod 0644 "$CERT_DIR"/*.crt "$CERT_DIR"/*.key "$CERT_DIR"/*.pem
# Specific case, postgresql checks key permissions
chmod 0640 "$CERT_DIR/db.key"

# Hold the container open: podman-compose injects podman-native --requires
# dependencies for every depends_on entry, and podman only accepts
# dependencies in the "Running" state. Readiness (certificates generated)
# is signaled by the healthcheck defined in dci.yml.
echo "==> Certificates ready, holding container open."

# Exit immediately on stop signals: as PID 1, an unhandled SIGTERM is
# ignored by the kernel, and `podman stop` would fall back to SIGKILL
# after the 10s timeout. `wait` is the only builtin interrupted by a
# trapped signal, hence the background sleep.
trap 'exit 0' TERM INT
while :; do
  sleep 3600 &
  wait $!
done
