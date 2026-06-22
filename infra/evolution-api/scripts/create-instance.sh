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

echo "Criando instancia '${EVOLUTION_INSTANCE_NAME}' na Evolution API..."

# Payload base para Evolution API v2.
# Confira a documentacao da versao usada caso os campos de criacao de instancia mudem.
curl --fail --silent --show-error \
  --request POST "${SERVER_URL}/instance/create" \
  --header "Content-Type: application/json" \
  --header "apikey: ${AUTHENTICATION_API_KEY}" \
  --data "{
    \"instanceName\": \"${EVOLUTION_INSTANCE_NAME}\",
    \"qrcode\": true,
    \"integration\": \"WHATSAPP-BAILEYS\"
  }"

echo
echo "Instancia solicitada com QR Code habilitado. Caso o QR nao apareca na resposta, execute o script connect-instance.sh."
