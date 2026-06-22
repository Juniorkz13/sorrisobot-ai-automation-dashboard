# Modelagem Inicial do Banco de Dados

Este documento descreve o schema inicial do Supabase para o SorrisoBot AI. A migration correspondente está em `supabase/migrations/202606220001_initial_schema.sql`.

## Objetivo do schema

O banco foi modelado para centralizar os dados reais do agente de atendimento odontológico via WhatsApp e alimentar o dashboard operacional. Ele será a fonte única de verdade para contatos, conversas, mensagens, eventos, fila de processamento, agendamentos, documentos de conhecimento e configurações do agente.

Nesta etapa, o schema cria estrutura e configurações iniciais. Ele não cria conversas falsas, mensagens falsas ou dados mockados para o dashboard.

## Tabelas criadas

- `contacts`: armazena pacientes e contatos identificados pelo telefone em formato E.164.
- `conversations`: representa o atendimento em andamento ou encerrado com um contato.
- `messages`: registra mensagens recebidas, enviadas e sistêmicas, incluindo conteúdo, mídia, intent, sentimento e metadados de IA.
- `conversation_events`: registra eventos importantes da conversa, como alteração de status, handoff humano ou erro.
- `message_queue`: prepara buffering e fila de mensagens antes do processamento pelo agente.
- `appointments`: registra solicitações e confirmações de agendamento, com espaço para integração futura com Google Agenda.
- `knowledge_documents`: guarda conteúdos internos que poderão alimentar uma estratégia de RAG.
- `agent_settings`: armazena configurações iniciais do agente, como nome da clínica, nome do agente, horário de atendimento e mensagens padrão.

## Relação entre contacts, conversations e messages

A relação principal segue este fluxo:

1. Um registro em `contacts` representa uma pessoa que entrou em contato pelo WhatsApp.
2. Uma ou mais conversas em `conversations` podem estar associadas ao contato por `contact_id`.
3. Cada mensagem em `messages` pertence a uma conversa por `conversation_id` e também pode apontar para o contato por `contact_id`.

Quando uma mensagem é inserida em `messages`, uma trigger atualiza automaticamente os agregados da conversa:

- `message_count`
- `inbound_count`
- `outbound_count`
- `last_message_at`
- `current_intent`, quando a nova intent não for `desconhecida`
- `sentiment`, quando o novo sentimento não for `neutro`
- `updated_at`

Essa estratégia evita que o dashboard precise recalcular contadores básicos a cada consulta.

## Como o n8n usará o banco

O n8n será responsável por receber webhooks da Evolution API, normalizar mensagens, localizar ou criar contatos e conversas, chamar o modelo Gemini e persistir os resultados.

Uso planejado pelo n8n:

- Consultar `contacts` por `phone_e164`.
- Criar ou atualizar contatos em `contacts`.
- Criar ou atualizar conversas em `conversations`.
- Inserir mensagens de entrada e saída em `messages`.
- Registrar eventos operacionais em `conversation_events`.
- Usar `message_queue` para buffering quando várias mensagens chegarem em sequência.
- Criar ou atualizar registros em `appointments` quando houver intenção de agendamento.
- Ler `agent_settings` para mensagens padrão e regras básicas de atendimento.
- Consultar `knowledge_documents` em uma etapa futura de RAG.

A escrita pelo n8n será feita futuramente com a `SUPABASE_SERVICE_ROLE_KEY`, guardada fora do Git e configurada apenas em ambiente seguro.

## Como o dashboard usará o banco

O dashboard em Next.js usará o Supabase para consultar dados reais gerados pelo agente.

Uso planejado pelo dashboard:

- Listar conversas a partir de `conversations`.
- Exibir contatos relacionados por `contacts`.
- Mostrar histórico completo por `messages`.
- Exibir eventos por `conversation_events`.
- Mostrar agendamentos por `appointments`.
- Alimentar indicadores por meio das views agregadas.
- Filtrar conversas por status, intent, sentimento e data.

O dashboard deverá usar autenticação antes de acessar dados operacionais. Não há policy pública para `anon`.

## Realtime

As tabelas `conversations`, `messages` e `conversation_events` são preparadas para Supabase Realtime por meio da publicação `supabase_realtime`, quando ela estiver disponível no ambiente.

Uso planejado:

- Atualizar a lista de conversas quando uma nova mensagem chegar.
- Atualizar o detalhe da conversa em tempo real.
- Refletir eventos como handoff humano, erro ou encerramento.
- Atualizar indicadores sem depender apenas de refresh manual.

Se a publicação não estiver disponível durante a aplicação da migration, o Realtime poderá ser habilitado manualmente no painel do Supabase.

## RLS e service role

Row Level Security é habilitado nas tabelas principais. As policies criadas permitem `SELECT` apenas para a role `authenticated` nas tabelas:

- `contacts`
- `conversations`
- `messages`
- `conversation_events`
- `appointments`
- `knowledge_documents`

Não há policy pública para `anon` e não há permissão de insert, update ou delete para usuários anônimos.

A escrita operacional do agente será feita em etapa futura com service role. A `SUPABASE_SERVICE_ROLE_KEY` nunca deve ser exposta no frontend, nunca deve ser versionada e deve ser usada somente em ambientes confiáveis, como n8n ou rotinas backend protegidas.

## Views para métricas

As views iniciais para o dashboard são:

- `v_dashboard_overview`: totais gerais de conversas, mensagens, conversas ativas, conversas aguardando humano, conversas encerradas, agendamentos confirmados e tempo médio de resposta.
- `v_conversations_by_day`: total de conversas e mensagens agrupadas por dia.
- `v_conversations_by_status`: total de conversas por status.
- `v_messages_by_intent`: total de mensagens por intent.

Essas views devem alimentar os primeiros cards, filtros e gráficos do dashboard usando dados reais gravados pelo agente.

## Status disponíveis

### conversation_status

- `em_andamento`
- `aguardando_humano`
- `agendamento_pendente`
- `agendado`
- `orcamento_enviado`
- `encerrada`
- `erro`

### queue_status

- `pending`
- `processing`
- `done`
- `failed`

### appointment_status

- `solicitado`
- `confirmado`
- `reagendado`
- `cancelado`
- `concluido`
- `erro`

## Intents disponíveis

### intent_type

- `saudacao`
- `duvida`
- `orcamento`
- `agendamento`
- `emergencia`
- `humano`
- `encerramento`
- `imagem`
- `audio`
- `fora_de_escopo`
- `desconhecida`

## Outros tipos relevantes

### message_direction

- `inbound`
- `outbound`
- `system`

### message_type

- `text`
- `image`
- `audio`
- `document`
- `video`
- `sticker`
- `unknown`

### sentiment_type

- `positivo`
- `neutro`
- `negativo`
- `urgente`
