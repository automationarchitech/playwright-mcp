#!/usr/bin/env bash
set -e
HOST=127.0.0.1 PORT=6274 PROXY_HOST=127.0.0.1 PROXY_PORT=6277 \
npx -y @modelcontextprotocol/inspector -- \
npx -y @playwright/mcp@latest --browser chrome --headless=false
