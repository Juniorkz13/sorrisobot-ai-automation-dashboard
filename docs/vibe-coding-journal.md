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
