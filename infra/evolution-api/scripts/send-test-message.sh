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

if [[ $# -lt 2 ]]; then
  echo "Uso: ./scripts/send-test-message.sh 55DDDNUMERO \"Mensagem de teste\""
  exit 1
fi

PHONE_NUMBER="$1"
MESSAGE_TEXT="$2"

if [[ -z "${SERVER_URL:-}" ]]; then
  echo "Variavel obrigatoria ausente: SERVER_URL"
  exit 1
fi

if [[ -z "${AUTHENTICATION_API_KEY:-}" ]]; then
  echo "Variavel obrigatoria ausente: AUTHENTICATION_API_KEY"
  exit 1
fi

if [[ -z "${EVOLUTION_INSTANCE_NAME:-}" ]]; then
  echo "Variavel obrigatoria ausente: EVOLUTION_INSTANCE_NAME"
  exit 1
fi

echo "Enviando mensagem de teste para ${PHONE_NUMBER} pela instancia '${EVOLUTION_INSTANCE_NAME}'..."

curl --fail --silent --show-error \
  --request POST "${SERVER_URL}/message/sendText/${EVOLUTION_INSTANCE_NAME}" \
  --header "Content-Type: application/json" \
  --header "apikey: ${AUTHENTICATION_API_KEY}" \
  --data "{
    \"number\": \"${PHONE_NUMBER}\",
    \"text\": \"${MESSAGE_TEXT}\",
    \"linkPreview\": false
  }"

echo
echo "Mensagem enviada com sucesso."
