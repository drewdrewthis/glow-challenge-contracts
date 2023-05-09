Copy code
#!/bin/bash

set -euo pipefail

if [[ ! -f .env ]]; then
  echo ".env file not found" >&2
  exit 1
fi

# Export environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Use double quotes for variable expansion to ensure word splitting and globbing
forge create \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY" \
  src/DrewToken.sol:DrewToken \
  --constructor-args "DrewToken" "DRU"