#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.openclaw"
TOKEN_FILE="$STATE_DIR/codespaces-gateway-token"
LOG_FILE="$HOME/openclaw-gateway.log"

mkdir -p "$STATE_DIR"
chmod 700 "$STATE_DIR"

if ! curl -fsS http://127.0.0.1:18789/ >/dev/null 2>&1; then
  if [ ! -s "$TOKEN_FILE" ]; then
    openssl rand -hex 32 > "$TOKEN_FILE"
    chmod 600 "$TOKEN_FILE"
  fi

  export OPENCLAW_GATEWAY_TOKEN
  OPENCLAW_GATEWAY_TOKEN="$(cat "$TOKEN_FILE")"

  nohup openclaw gateway run \
    --allow-unconfigured \
    --bind lan \
    --port 18789 \
    --auth token \
    > "$LOG_FILE" 2>&1 < /dev/null &
fi

for attempt in $(seq 1 30); do
  if curl -fsS http://127.0.0.1:18789/ >/dev/null 2>&1; then
    echo "OpenClaw Gateway is responding on port 18789."
    echo "Gateway token is stored privately at: $TOKEN_FILE"
    exit 0
  fi
  sleep 2
done

echo "Gateway did not become ready. Recent log output:"
tail -n 60 "$LOG_FILE" || true
exit 1
