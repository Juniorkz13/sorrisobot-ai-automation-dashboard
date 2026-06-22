#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [[ -f "${INFRA_DIR}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${INFRA_DIR}/.env"
  set +a
else
  echo "Arquivo .env nao encontrado em infra/evolution-api."
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Uso: ./scripts/connect-pairing-code.sh 55DDDNUMERO"
  exit 1
fi

PHONE="$1"

echo "Solicitando pairing code para a instancia '${EVOLUTION_INSTANCE_NAME}' usando o numero '${PHONE}'..."

curl --fail --silent --show-error \
  --request GET "${SERVER_URL}/instance/connect/${EVOLUTION_INSTANCE_NAME}?number=${PHONE}" \
  --header "apikey: ${AUTHENTICATION_API_KEY}"

echo