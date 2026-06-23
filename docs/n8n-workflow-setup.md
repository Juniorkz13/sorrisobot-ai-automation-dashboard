# Setup do Workflow n8n

Este documento registra a Etapa 5 do SorrisoBot AI: validação inicial do agente WhatsApp no n8n Cloud, integrado com Evolution API, Supabase e Gemini API.

## Nome do workflow

`SorrisoBot AI - WhatsApp Agent v1`

Arquivo exportado:

`workflows/n8n/SorrisoBot AI - WhatsApp Agent v1.json`

## Status da etapa

O workflow inicial foi validado com sucesso de ponta a ponta.

Fluxo validado:

```text
WhatsApp real
→ Evolution API
→ Webhook n8n
→ Normalize Evolution Payload
→ filtro de mensagem válida
→ Supabase salva contato, conversa e mensagem inbound
→ Gemini gera resposta
→ extração da resposta
→ Evolution API envia resposta
→ Supabase salva mensagem outbound
→ Supabase registra evento agent_response_sent
```

Esta etapa valida o caminho mínimo funcional do agente. Intents avançadas, memória mais sofisticada, RAG, áudio, imagem e Google Agenda serão adicionados em etapas futuras.

## Arquitetura do fluxo

O n8n Cloud atua como orquestrador do atendimento. A Evolution API recebe os eventos do WhatsApp e encaminha o payload para o webhook do n8n. O workflow normaliza o payload, descarta mensagens inválidas, persiste dados no Supabase, chama o Gemini API, envia a resposta pelo WhatsApp e registra o resultado final no banco do produto.

Responsabilidades por componente:

- **Evolution API**: receber eventos do WhatsApp e enviar mensagens de resposta.
- **n8n Cloud**: orquestrar validação, persistência, chamada de IA e envio.
- **Supabase**: armazenar contatos, conversas, mensagens inbound/outbound, eventos e contadores.
- **Gemini API**: gerar a resposta inicial do agente.

## Lista de nodes usados

Nodes presentes no workflow exportado:

- `Webhook`
- `Normalize Evolution Payload`
- `Is Valid Inbound Text Message?`
- `Gemini`
- `Supabase`
- `Supabase - Upsert Contact`
- `Supabase - Get Or Create Conversation`
- `Supabase - Save Inbound Message`
- `Gemini - Generate Response`
- `Extract Gemini Response`
- `Evolution API`
- `Evolution API - Send WhatsApp Message`
- `Prepare WhatsApp Message Body`
- `Prepare Outbound Message Body`
- `HTTP Request`
- `Prepare Conversation Event Body`
- `Supabase - Save Conversation Event`

Observação: alguns nodes genéricos podem ser renomeados em uma etapa futura para refletir melhor sua responsabilidade no fluxo.

## Variáveis necessárias

As credenciais devem ser configuradas no n8n Cloud como variáveis ou credenciais seguras. Não versionar valores reais.

```env
SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
GEMINI_API_KEY=
EVOLUTION_API_URL=
EVOLUTION_API_KEY=
EVOLUTION_INSTANCE_NAME=
```

Cuidados:

- `SUPABASE_SERVICE_ROLE_KEY` deve ser usada apenas no ambiente seguro do n8n.
- `GEMINI_API_KEY` nunca deve ser exposta em frontend ou documentação pública.
- `EVOLUTION_API_KEY` deve ser a mesma chave configurada na Evolution API.
- Chaves sensíveis usadas durante validações devem ser rotacionadas antes da entrega final.

## URLs do Webhook n8n

Durante o desenvolvimento foi usada a **Test URL** do webhook do n8n. Ela é útil para executar o workflow manualmente, inspecionar payloads e validar ajustes enquanto o workflow está em modo de teste.

Quando o workflow estiver ativo, a Evolution API deverá apontar para a **Production URL** do webhook. A Production URL é a URL correta para operação contínua, pois não depende de uma execução de teste aberta no editor do n8n.

Não documentar URLs reais temporárias no repositório.

## URL pública da Evolution API

Como o workflow está no n8n Cloud, o node que envia resposta ao WhatsApp precisa acessar a Evolution API por uma URL pública.

Durante desenvolvimento local, a Evolution API pode rodar via Docker Compose. Para a validação em nuvem e para a entrega final, é necessário publicar a Evolution API em um ambiente acessível pelo n8n Cloud, como uma VPS simples ou plataforma de deploy compatível com Docker.

Não usar URLs temporárias reais em documentação versionada.

## Payload validado para envio de texto

Na versão validada da Evolution API, o envio de mensagem de texto funcionou com o campo `text` na raiz do JSON.

Endpoint usado pelo fluxo:

```text
POST ${EVOLUTION_API_URL}/message/sendText/${EVOLUTION_INSTANCE_NAME}
```

Headers:

```text
Content-Type: application/json
apikey: ${EVOLUTION_API_KEY}
```

Body validado:

```json
{
  "number": "5511999999999",
  "text": "Olá, esta é uma resposta do SorrisoBot AI."
}
```

O número acima é apenas um placeholder de documentação. Não registrar números reais de pacientes no repositório.

## Função Supabase get_or_create_open_conversation

O workflow usa a função `get_or_create_open_conversation` para reutilizar uma conversa aberta do contato ou criar uma nova conversa quando necessário.

Arquivo da migration:

`supabase/migrations/202606220002_get_or_create_open_conversation.sql`

Responsabilidades da função:

- Receber `contact_id` e instância.
- Procurar conversa aberta do contato.
- Reutilizar conversa com status operacional aberto.
- Criar nova conversa quando não existir uma aberta.
- Registrar evento `conversation_created` quando uma nova conversa for criada.
- Retornar os dados principais da conversa para o workflow.

Essa função simplifica o workflow no n8n e centraliza a regra de abertura/reutilização de conversa no banco.

## Validação final

Itens validados na Etapa 5:

- [x] Contato salvo no Supabase.
- [x] Conversa criada ou reutilizada.
- [x] Mensagem inbound salva.
- [x] Gemini respondeu.
- [x] WhatsApp recebeu resposta.
- [x] Mensagem outbound salva.
- [x] Evento `agent_response_sent` salvo.
- [x] Contadores `message_count`, `inbound_count` e `outbound_count` atualizados.

## Problemas encontrados e correções

### Webhook da Evolution exigiu wrapper `webhook`

Ao configurar o webhook da Evolution API, foi necessário enviar o payload com o wrapper `webhook`, conforme exigido pela versão usada.

Correção: ajustar o body do script/configuração de webhook para respeitar o formato esperado pela API.

### `.env` falhou por espaço depois de `=`

Uma variável no `.env` falhou por causa de espaço depois do sinal `=`.

Correção: manter o formato sem espaços:

```env
NOME_DA_VARIAVEL=valor
```

### JSON body do n8n quebrou com quebras de linha da resposta do Gemini

A resposta do Gemini pode conter quebras de linha e caracteres que quebram um JSON montado manualmente no body de um node HTTP.

Correção: usar um Code node para preparar o body e aplicar `JSON.stringify` antes do envio.

### 401 na Evolution API

O envio para a Evolution API retornou `401 Unauthorized` quando a chave usada não correspondia à API key configurada.

Correção: usar a `AUTHENTICATION_API_KEY` correta da Evolution API como `EVOLUTION_API_KEY` no n8n.

### Rotação de chaves sensíveis

Durante validações, chaves e endpoints podem aparecer em logs, prints ou payloads temporários.

Correção: rotacionar chaves sensíveis antes da entrega final e revisar documentação, workflow exportado e prints para garantir que nenhum segredo real seja publicado.

## Próximos passos

- Ativar o workflow com Production URL.
- Revisar e renomear nodes genéricos.
- Evoluir classificação de intents.
- Adicionar memória avançada.
- Preparar RAG para documentos da clínica.
- Adicionar tratamento de áudio e imagem.
- Planejar integração com Google Agenda.
- Criar evidência em vídeo do agente funcionando.
