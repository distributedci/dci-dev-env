#!/usr/bin/env python3
import os
import sys
import urllib.parse

# Frontend actor credentials from environment
VALID_USER: str = os.getenv("PROXY_USER", "")
VALID_PASS: str = os.getenv("PROXY_PASS", "")


def log(msg):
    print(f"AUTH_HELPER: {msg}", file=sys.stderr)


while True:
    line: str = sys.stdin.readline()
    if not line:
        break

    parts: list[str] = line.split()
    log(parts)
    if len(parts) < 2:
        continue

    username: str = urllib.parse.unquote(parts[0])
    password: str = urllib.parse.unquote(parts[1])

    if username == VALID_USER and password == VALID_PASS:
        log(f"AUTHN OK {username}.")
        if len(parts) > 2:
            domain: str = parts[2]
            if "quay.io" in domain:
                tag = "IS_QUAY"
            elif "registry.ci.openshift.org" in domain:
                tag = "IS_OPENSHIFT_CI"
            elif "r2.cloudflarestorage.com" in domain:
                tag = "IS_CLOUDFLARE"
            elif "s3.amazonaws.com" in domain:
                tag = "IS_AMAZON_S3"
            else:
                # only allow proxying to the domains above
                log(f"AUTHZ FAIL {username}.")
                sys.stdout.write("ERR\n")
                sys.stdout.flush()
                continue

            log(f"AUTHZ OK {username} {tag}.")
            sys.stdout.write(f"OK tag={tag}\n")
        else:
            sys.stdout.write("OK\n")
    else:
        log(f"AUTHN FAIL {username}.")
        sys.stdout.write("ERR\n")

    sys.stdout.flush()
