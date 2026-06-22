# Setup da Evolution API

Este documento descreve a preparação da Evolution API v2 para o projeto SorrisoBot AI.

A Evolution API será usada como camada de integração com o WhatsApp: ela receberá eventos de mensagens, conexão e QR Code, e também enviará mensagens de resposta quando o n8n solicitar.

## Objetivo da Evolution API no projeto

No SorrisoBot AI, a Evolution API fará a ponte entre WhatsApp e n8n Cloud.

Fluxo planejado:

1. O paciente envia uma mensagem para o WhatsApp da Clínica Sorriso Vivo.
2. A Evolution API recebe o evento.
3. A Evolution API envia o evento para um webhook do n8n Cloud.
4. O n8n processa a mensagem, chama o Gemini API e registra os dados no Supabase do produto.
5. O n8n solicita à Evolution API o envio da resposta ao WhatsApp.

Nesta etapa, ainda não há workflow n8n funcional nem integração final configurada.

## Por que a Evolution API tem Postgres e Redis próprios

A Evolution API precisa armazenar dados internos de sessão, instâncias, conexão e operação. Esses dados pertencem à infraestrutura da própria API, não ao produto SorrisoBot AI.

Por isso, a decisão técnica desta etapa é executar a Evolution API com serviços internos dedicados:

- Evolution API
- PostgreSQL dedicado para a Evolution API
- Redis dedicado para cache e fila interna da Evolution API

## Diferença entre Evolution API e Supabase

O PostgreSQL da Evolution API é um banco técnico e interno da integração WhatsApp. Ele não será usado pelo dashboard e não será a fonte de métricas do produto.

O Supabase é o banco do produto. Ele será usado pelo n8n para salvar:

- contatos
- conversas
- mensagens
- eventos
- memória
- métricas
- agendamentos
- dados consumidos pelo dashboard em tempo real

Essa separação evita acoplamento indevido entre a infraestrutura do WhatsApp e a modelagem de negócio do SorrisoBot AI.

## Pré-requisitos

- Docker instalado.
- Docker Compose disponível.
- Ambiente com URL pública na etapa final, para que o n8n Cloud e a Evolution API consigam trocar eventos.

Para desenvolvimento local, é possível subir a Evolution API em `http://localhost:8080`, mas o webhook do n8n Cloud exigirá uma URL acessível publicamente na demonstração final.

## Estrutura dos arquivos

```text
infra/evolution-api/
├── docker-compose.yml
├── .env.example
└── scripts/
    ├── healthcheck.sh
    ├── create-instance.sh
    ├── connect-instance.sh
    ├── set-webhook.sh
    └── send-test-message.sh
```

## Configuração do ambiente

Acesse a pasta da infraestrutura:

```bash
cd infra/evolution-api
```

Copie o template de variáveis:

```bash
cp .env.example .env
```

Preencha o arquivo `.env` com os valores reais do seu ambiente.

Variáveis principais:

- `SERVER_URL`: URL da Evolution API.
- `AUTHENTICATION_API_KEY`: chave forte para proteger a API.
- `EVOLUTION_INSTANCE_NAME`: nome da instância, inicialmente `sorrisobot`.
- `DATABASE_CONNECTION_URI`: conexão com o PostgreSQL interno da Evolution API.
- `CACHE_REDIS_URI`: conexão com o Redis interno da Evolution API.
- `N8N_WEBHOOK_URL`: URL pública do webhook do n8n Cloud.

Não versionar o arquivo `.env`.

## Subir localmente

Na pasta `infra/evolution-api`, execute:

```bash
docker compose up -d
```

Esse comando sobe:

- `sorrisobot_evolution_api`
- `sorrisobot_evolution_postgres`
- `sorrisobot_evolution_redis`

## Ver logs

```bash
docker logs sorrisobot_evolution_api
```

Para acompanhar logs em tempo real:

```bash
docker logs -f sorrisobot_evolution_api
```

## Testar healthcheck

Execute:

```bash
./scripts/healthcheck.sh
```

O script faz uma chamada `GET` em `SERVER_URL` e informa se a Evolution API respondeu.

## Criar instância

Execute:

```bash
./scripts/create-instance.sh
```

O script cria a instância definida em `EVOLUTION_INSTANCE_NAME`, usando o header `apikey`.

O payload foi preparado para Evolution API v2, mas pode precisar de ajuste conforme a versão exata da imagem usada. Antes da entrega final, valide o endpoint e o formato do payload na documentação da versão em execução.

## Conectar via QR Code ou pairing

Execute:

```bash
./scripts/connect-instance.sh
```

O script chama:

```text
GET ${SERVER_URL}/instance/connect/${EVOLUTION_INSTANCE_NAME}
```

A resposta pode conter QR Code, `pairingCode` ou `code`, dependendo da versão e configuração da Evolution API.

## Configurar webhook para o n8n Cloud

Preencha `N8N_WEBHOOK_URL` no arquivo `.env` com a URL real do webhook do n8n Cloud.

Depois execute:

```bash
./scripts/set-webhook.sh
```

Eventos configurados:

- `MESSAGES_UPSERT`
- `CONNECTION_UPDATE`
- `QRCODE_UPDATED`
- `SEND_MESSAGE`

O script usa um endpoint comum de webhook por instância na Evolution API v2. Caso a versão usada tenha endpoint diferente, ajuste o script conforme a documentação oficial.

## Enviar mensagem de teste

Com a instância conectada, execute:

```bash
./scripts/send-test-message.sh 5511999999999 "Ola, teste"
```

O script chama:

```text
POST ${SERVER_URL}/message/sendText/${EVOLUTION_INSTANCE_NAME}
```

O corpo enviado segue o formato:

```json
{
  "number": "5511999999999",
  "textMessage": {
    "text": "Ola, teste"
  }
}
```

## Cuidados com segurança

- Não versionar `infra/evolution-api/.env`.
- Usar uma `AUTHENTICATION_API_KEY` forte.
- Não expor painel ou API sem proteção.
- Não usar número principal pessoal, se possível.
- Rotacionar chaves se forem expostas acidentalmente.
- Não reutilizar senhas fracas em Postgres ou Redis.
- Evitar publicar logs com tokens, payloads sensíveis ou dados pessoais.

## Estratégia de publicação

A estratégia inicial permite desenvolvimento local opcional com Docker Compose.

Para a entrega final, a Evolution API precisará de uma URL pública estável para comunicação com o n8n Cloud. Opções possíveis:

- Railway
- VPS simples com Docker Compose

A escolha final deve considerar estabilidade, facilidade de demonstração, proteção da API e controle dos logs.

## Checklist da etapa

- [ ] Docker instalado.
- [ ] Docker Compose disponível.
- [ ] `.env.example` criado.
- [ ] `.env` criado localmente e ignorado pelo Git.
- [ ] API key forte definida.
- [ ] PostgreSQL interno configurado.
- [ ] Redis interno configurado.
- [ ] Evolution API iniciada com `docker compose up -d`.
- [ ] Healthcheck executado.
- [ ] Instância `sorrisobot` criada.
- [ ] Instância conectada via QR Code ou pairing.
- [ ] Webhook configurado para o n8n Cloud.
- [ ] Mensagem de teste enviada.
- [ ] Estratégia de URL pública definida para a entrega final.

### Validação local concluída

A Evolution API foi validada localmente com sucesso.

Resultados obtidos:

- Instância `sorrisobot` criada com `qrcode: true`
- QR Code gerado corretamente
- WhatsApp conectado à instância
- Status da instância validado como `open`
- Envio de mensagem testado com sucesso via endpoint `/message/sendText/{instance}`

Correções importantes aplicadas durante o setup:

- Ajuste do script `create-instance.sh` para usar `qrcode: true`
- Correção de variáveis com espaços no `.env`
- Identificação de que `EVOLUTION_API_IMAGE` no `.env` sobrescrevia a imagem definida no `docker-compose.yml`
- Validação da imagem `evoapicloud/evolution-api:v2.3.7`
- Ajuste do payload de envio de texto para usar `text` diretamente na raiz do JSON
