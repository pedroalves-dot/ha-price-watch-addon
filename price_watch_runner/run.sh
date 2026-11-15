#!/usr/bin/env bash
# Downloads the Price watch code from GitHub, then lets scripts/home.mjs wait for the next check
# (scheduled times, or "check now" from the web app / Telegram), run it, and exit. Repeat.
set -uo pipefail

OPTS=/data/options.json
export GITHUB_REPO=$(jq -r '.repo' "$OPTS")
export GITHUB_TOKEN=$(jq -r '.github_token' "$OPTS" | tr -d '[:space:]')
export TELEGRAM_BOT_TOKEN=$(jq -r '.telegram_bot_token' "$OPTS" | tr -d '[:space:]')
export TELEGRAM_CHAT_ID=$(jq -r '.telegram_chat_id' "$OPTS" | tr -d '[:space:]')
export CHECK_TIMES=$(jq -r '.check_times' "$OPTS")
export LAST_RUN_FILE=/data/last-run.json
APP=/data/app

# The old GitHub runner (v1) lived here; free the space.
rm -rf /data/runner

if [ -z "$GITHUB_TOKEN" ] || [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
  echo "Fill in github_token, telegram_bot_token and telegram_chat_id in the Configuration tab, save, and restart."
  sleep 3600; exit 1
fi

while true; do
  rm -rf "$APP.new" && mkdir -p "$APP.new"
  if curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPO/tarball/main" \
     | tar xz --strip-components=1 -C "$APP.new"; then
    rm -rf "$APP" && mv "$APP.new" "$APP"
  elif [ -d "$APP" ]; then
    echo "Couldn't download the latest code; using the copy from last time."
  else
    echo "Couldn't download the code from $GITHUB_REPO — check the repo name and that the token can read it. Retrying in 5 minutes."
    sleep 300; continue
  fi

  cd "$APP" && node --max-old-space-size=96 scripts/home.mjs
  cd / && sleep 10
done
