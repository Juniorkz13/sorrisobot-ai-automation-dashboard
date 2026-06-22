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

echo "Verificando Evolution API em ${SERVER_URL}..."

if curl --fail --silent --show-error --max-time 10 "${SERVER_URL}" >/tmp/sorrisobot_evolution_healthcheck_response.txt; then
  echo "Evolution API respondeu com sucesso."
else
  echo "Evolution API nao respondeu corretamente."
  exit 1
fi
