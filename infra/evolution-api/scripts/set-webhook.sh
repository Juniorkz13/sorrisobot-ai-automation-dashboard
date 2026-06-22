#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

load_env() {
  if [[ -f "${INFRA_DIR}/.env" ]]; then
    set -a
    # shellcheck disable=SC1091
    source "${INFRA_DIR}/.env"
    set +a
  elif [[ -f ".env" ]]; then
    set -a
    # shellcheck disable=SC1091
    source ".env"
    set +a
  else
    echo "Arquivo .env nao encontrado. Copie .env.example para .env em infra/evolution-api."
    exit 1
  fi
}

require_var() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "Variavel obrigatoria ausente: ${name}"
    exit 1
  fi
}

load_env
require_var "SERVER_URL"
require_var "AUTHENTICATION_API_KEY"
require_var "EVOLUTION_INSTANCE_NAME"
require_var "N8N_WEBHOOK_URL"

echo "Configurando webhook da instancia '${EVOLUTION_INSTANCE_NAME}' para o n8n..."

# Endpoint comum em versoes v2: /webhook/set/{instanceName}.
# Caso a versao usada exponha outro endpoint, ajuste este script conforme a documentacao oficial.
curl --fail --silent --show-error \
  --request POST "${SERVER_URL}/webhook/set/${EVOLUTION_INSTANCE_NAME}" \
  --header "Content-Type: application/json" \
  --header "apikey: ${AUTHENTICATION_API_KEY}" \
  --data "{
    \"webhook\": {
      \"enabled\": ${WEBHOOK_ENABLED:-true},
      \"url\": \"${N8N_WEBHOOK_URL}\",
      \"byEvents\": true,
      \"base64\": false,
      \"events\": [
        \"MESSAGES_UPSERT\",
        \"CONNECTION_UPDATE\",
        \"QRCODE_UPDATED\",
        \"SEND_MESSAGE\"
      ]
    }
  }"

echo
echo "Webhook configurado. Valide no n8n Cloud se os eventos estao chegando corretamente."
