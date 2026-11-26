FROM registry.access.redhat.com/ubi10/ubi-minimal:latest

ENV MKCERT_VERSION="v1.4.4"

RUN microdnf update -y && \
  microdnf install -y --nodocs \
  curl \
  ca-certificates \
  bash \
  && microdnf clean all

RUN ARCH=$(uname -m) && \
  if [ "$ARCH" = "x86_64" ]; then MKCERT_ARCH="amd64"; \
  elif [ "$ARCH" = "aarch64" ]; then MKCERT_ARCH="arm64"; \
  else MKCERT_ARCH="amd64"; fi && \
  curl -sL "https://github.com/FiloSottile/mkcert/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-linux-${MKCERT_ARCH}" \
  -o /usr/local/bin/mkcert && \
  chmod +x /usr/local/bin/mkcert

COPY generate-certs.sh /generate-certs.sh
RUN chmod +x /generate-certs.sh

ENTRYPOINT ["/generate-certs.sh"]
