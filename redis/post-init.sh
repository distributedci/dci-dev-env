# This file serves for extending the container image, typically by changing
# the configuration, loading some data etc.

# Feel free to add content to this file or rewrite it at all.
# You may also start redis server locally to load some data for example,
# but do not forget to stop it after it, so it can be restarted after it.

source "${CONTAINER_SCRIPTS_PATH}/common.sh"
set -eu

setup_bind_address

echo "==> Injecting TLS configuration ..."
cat <<EOF >>"${REDIS_CONF}"
port 0
tls-port 6379
tls-cert-file /certs/redis.crt
tls-key-file /certs/redis.key
tls-ca-cert-file /certs/ca.crt
tls-auth-clients no
EOF
