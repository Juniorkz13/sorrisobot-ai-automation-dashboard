# Vibe Coding Journal

Este documento registra o uso de IA durante o desenvolvimento do SorrisoBot AI. A proposta é manter transparência sobre prompts utilizados, resultados obtidos, decisões técnicas e correções manuais.

## Registro 001

- **Data**:
- **Ferramenta usada**:
- **Prompt utilizado**:
- **Resultado obtido**:
- **Onde a IA acertou**:
- **Onde a IA falhou**:
- **Correções manuais feitas**:
- **Decisão técnica tomada**:

## Modelo para novos registros

```md
## Registro NNN

- **Data**:
- **Ferramenta usada**:
- **Prompt utilizado**:
- **Resultado obtido**:
- **Onde a IA acertou**:
- **Onde a IA falhou**:
- **Correções manuais feitas**:
- **Decisão técnica tomada**:
```

## 2026-06-22 — Preparação de ferramentas

- Ferramenta usada: Codex
- Prompt utilizado: documentação de setup das ferramentas e variáveis de ambiente
- Resultado obtido: criação do arquivo `docs/setup-tools.md`, atualização do `README.md` e criação do `.env.example`
- Onde a IA acertou: organizou as ferramentas e separou variáveis públicas e sensíveis
- Onde a IA falhou: ainda não avaliado
- Correções manuais feitas: revisão para garantir que nenhuma chave real foi versionada
- Decisão técnica tomada: usar Supabase como banco central e preparar n8n/Evolution API para integração real nas próximas etapas

## 2026-06-22 — Modelagem inicial do banco Supabase

- Ferramenta usada: Codex
- Prompt utilizado: criação da migration inicial do schema Supabase
- Resultado obtido: criação das tabelas principais do agente, mensagens, conversas, fila, agendamentos, base de conhecimento, configurações e views de métricas
- Onde a IA acertou: estruturou o banco pensando no agente e no dashboard desde o início
- Onde a IA falhou: ainda não avaliado
- Correções manuais feitas: validação da migration no SQL Editor do Supabase e remoção dos dados temporários de teste
- Decisão técnica tomada: usar Supabase como fonte única da verdade para histórico, memória, métricas e realtime

## 2026-06-22 — Preparação da infraestrutura Evolution API

- Ferramenta usada: Codex
- Prompt utilizado: criação de infraestrutura Docker Compose e scripts para Evolution API
- Resultado obtido: estrutura inicial da Evolution API, scripts auxiliares e documentação de setup
- Onde a IA acertou: separar banco interno da Evolution API do Supabase do produto
- Onde a IA falhou: ainda não avaliado
- Correções manuais feitas: validar endpoints conforme versão da Evolution API usada
- Decisão técnica tomada: usar Evolution API v2 com Docker Compose e instância controlada chamada sorrisobot

## 2026-06-22 — Preparação da infraestrutura Evolution API

- Ferramenta usada: Codex
- Prompt utilizado: criação de infraestrutura Docker Compose e scripts para Evolution API
- Resultado obtido: Evolution API executando localmente, instância `sorrisobot` criada, WhatsApp conectado e envio de mensagem validado
- Onde a IA acertou: separou corretamente a Evolution API do Supabase e estruturou scripts auxiliares para healthcheck, criação de instância, conexão, webhook e envio de mensagem
- Onde a IA falhou: o script inicial criou instância com `qrcode: false`; o payload inicial de envio usava `textMessage.text`, mas a imagem validada exigiu `text` na raiz; a variável `EVOLUTION_API_IMAGE` no `.env` sobrescreveu a imagem planejada no compose
- Correções manuais feitas: ajuste para `qrcode: true`, correção de aspas no `.env`, troca/validação da imagem `evoapicloud/evolution-api:v2.3.7`, limpeza de volumes, regeneração de QR Code e correção do script `send-test-message.sh`
- Decisão técnica tomada: usar Evolution API v2 com Docker Compose, Postgres e Redis próprios, mantendo Supabase separado como banco do produto

## 2026-06-22 — Etapa 5: workflow n8n validado ponta a ponta

- Ferramenta usada: Codex e n8n Cloud
- Prompt utilizado: documentação da validação do workflow inicial do agente WhatsApp
- Resultado obtido: workflow funcional ponta a ponta, passando por WhatsApp real, Evolution API, webhook n8n, Supabase, Gemini, envio de resposta e registro de evento
- Onde a IA acertou: estrutura do fluxo
- Onde a IA falhou: payloads e detalhes específicos da versão real
- Correções manuais feitas: ajuste do wrapper `webhook` na Evolution API, correção de `.env` com espaço depois de `=`, correção do body JSON quebrado por quebras de linha do Gemini usando Code node e `JSON.stringify`, ajuste da API key correta para resolver 401 na Evolution API e registro da necessidade de rotacionar chaves sensíveis antes da entrega final
- Decisão técnica tomada: primeiro validar fluxo simples antes de adicionar intents, memória avançada, RAG, áudio, imagem e Google Agenda
