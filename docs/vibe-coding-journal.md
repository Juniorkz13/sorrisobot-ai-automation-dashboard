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
