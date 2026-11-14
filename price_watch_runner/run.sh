#!/usr/bin/env bash
# Downloads GitHub's Actions runner into /data (kept across restarts/updates),
# registers it once with the token from the Configuration tab, then waits for jobs.
set -euo pipefail

OPTS=/data/options.json
REPO_URL=$(jq -r '.repo_url' "$OPTS")
TOKEN=$(jq -r '.registration_token // ""' "$OPTS")
NAME=$(jq -r '.runner_name // "home-assistant"' "$OPTS")
export RUNNER_ALLOW_RUNASROOT=1

DIR=/data/runner
mkdir -p "$DIR"
cd "$DIR"

if [ ! -f ./config.sh ]; then
  case "$(uname -m)" in
    aarch64) ARCH=arm64 ;;
    x86_64)  ARCH=x64 ;;
    *) echo "Unsupported CPU: $(uname -m) (needs a 64-bit system)"; sleep 3600; exit 1 ;;
  esac
  VERSION=$(curl -fsSL https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/^v//')
  echo "Downloading GitHub runner ${VERSION} (${ARCH})…"
  curl -fsSL -o runner.tgz "https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-${ARCH}-${VERSION}.tar.gz"
  tar xzf runner.tgz && rm runner.tgz
fi

if [ ! -f .runner ]; then
  if [ -z "$TOKEN" ]; then
    echo "Not registered yet: paste a registration token in the add-on's Configuration tab, save, and restart."
    sleep 3600; exit 1
  fi
  echo "Registering runner '${NAME}' with ${REPO_URL}…"
  ./config.sh --unattended --url "$REPO_URL" --token "$TOKEN" --name "$NAME" --labels home --replace
  echo "Registered. The token is no longer needed."
fi

echo "Waiting for price checks…"
exec ./run.sh
