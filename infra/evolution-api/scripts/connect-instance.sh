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

echo "Solicitando dados de conexao para a instancia '${EVOLUTION_INSTANCE_NAME}'..."
echo "A resposta pode conter pairingCode, code ou QR Code, conforme a versao/configuracao da Evolution API."

curl --fail --silent --show-error \
  --request GET "${SERVER_URL}/instance/connect/${EVOLUTION_INSTANCE_NAME}" \
  --header "apikey: ${AUTHENTICATION_API_KEY}"

echo
