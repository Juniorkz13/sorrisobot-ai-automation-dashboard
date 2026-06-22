# Preparação das Ferramentas

Este documento registra as ferramentas externas que serão usadas no SorrisoBot AI, quais contas ou cadastros são necessários, quais variáveis devem ser guardadas fora do Git e quais decisões técnicas foram tomadas nesta etapa.

O projeto ainda está em fase de preparação. As integrações descritas aqui representam a direção técnica planejada e não indicam que os serviços já estejam configurados ou funcionando.

## 1. GitHub

O GitHub será usado para versionamento do código, documentação e entrega do teste técnico.

### Decisões iniciais

- O repositório deverá ser público para facilitar a avaliação técnica.
- Nome do repositório: `sorrisobot-ai-automation-dashboard`.
- A branch principal deverá conter apenas arquivos revisados, sem credenciais e sem dados sensíveis.

### Cuidados com commits

- Não commitar arquivos `.env`, `.env.local` ou equivalentes.
- Revisar o diff antes de cada commit.
- Evitar commits com logs, prints locais, arquivos temporários ou dados privados.
- Manter mensagens de commit claras e relacionadas ao escopo da alteração.
- Registrar decisões relevantes na documentação do projeto.

## 2. Supabase

O Supabase será usado como banco Postgres, base de memória, histórico de conversas, autenticação futura do dashboard e camada de Realtime.

### Decisões iniciais

- Criar um projeto chamado `sorrisobot-ai`.
- Usar o Postgres do Supabase como fonte única de verdade para conversas, contatos, mensagens, intents, status e métricas.
- Usar Supabase Realtime futuramente para refletir novas mensagens e alterações de status no dashboard.

### Variáveis necessárias

```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
SUPABASE_DB_URL=
```

### Cuidados de segurança

- `NEXT_PUBLIC_SUPABASE_URL` e `NEXT_PUBLIC_SUPABASE_ANON_KEY` podem ser usadas no frontend, respeitando as políticas de segurança do Supabase.
- `SUPABASE_SERVICE_ROLE_KEY` nunca deve ser exposta no frontend.
- `SUPABASE_SERVICE_ROLE_KEY` deve ser usada apenas em ambientes seguros, como n8n, rotinas backend ou configurações protegidas.
- `SUPABASE_DB_URL` deve ser tratada como sensível e mantida fora do Git.

## 3. Google AI Studio / Gemini API

O Google AI Studio será usado para gerar uma chave de API do Gemini, modelo planejado para interpretação de mensagens, classificação de intents e geração de respostas do agente.

### Decisões iniciais

- Criar uma API key no Google AI Studio.
- Definir o modelo por variável de ambiente para permitir troca futura sem alteração direta no código ou no workflow.

### Variáveis necessárias

```env
GEMINI_API_KEY=
GEMINI_MODEL=
```

### Cuidados de segurança

- `GEMINI_API_KEY` nunca deve ser versionada.
- A chave deve ser configurada localmente, no n8n ou em plataformas de deploy somente por meio de variáveis de ambiente.
- Se a chave for exposta por acidente, ela deve ser revogada e recriada imediatamente.

## 4. Vercel

A Vercel será usada futuramente para o deploy público do dashboard em Next.js.

### Decisões iniciais

- O login deverá ser feito com GitHub para facilitar a conexão com o repositório.
- O deploy será configurado em etapa futura, quando o dashboard estiver implementado.
- As variáveis de ambiente do dashboard serão configuradas posteriormente no painel da Vercel.

### Cuidados

- Não inventar nem documentar URL pública antes do deploy real.
- Não armazenar secrets diretamente no código.
- Validar as variáveis necessárias antes de publicar o dashboard.

## 5. n8n

O n8n será o orquestrador principal do agente de atendimento via WhatsApp.

### Opções consideradas

- **n8n Cloud**: facilita disponibilidade, manutenção e webhooks públicos.
- **n8n self-hosted**: oferece mais controle sobre infraestrutura, custo e configuração, mas exige manutenção do ambiente.

### Decisão inicial

A decisão inicial é usar um ambiente que facilite webhook público e demonstração do teste técnico. A escolha final entre n8n Cloud e self-hosted será documentada antes da implementação do workflow funcional.

### Entrega futura

- O workflow será exportado como JSON futuramente.
- O arquivo exportado deverá ficar em `workflows/n8n`.
- Credenciais do n8n não devem ser exportadas nem versionadas.

## 6. Evolution API

A Evolution API será usada para receber mensagens do WhatsApp e enviar respostas automáticas geradas pelo agente.

### Decisões iniciais

- Desenvolver com uma instância controlada e documentada.
- Registrar claramente qual ambiente foi usado para demonstração.
- Manter dados de autenticação fora do Git.

### Variáveis necessárias

```env
EVOLUTION_API_URL=
EVOLUTION_API_KEY=
EVOLUTION_INSTANCE_NAME=
```

### Cuidados

- `EVOLUTION_API_KEY` deve ser tratada como secret.
- `EVOLUTION_API_URL` não deve expor ambientes privados quando isso representar risco de segurança.
- O nome da instância deve ser documentado sem incluir credenciais.

## 7. Segurança

As integrações planejadas exigem chaves de API, tokens e credenciais. Esses valores nunca devem ser publicados no repositório.

### Regras do projeto

- Nunca commitar arquivos `.env.local`.
- Nunca expor tokens, API keys, senhas ou connection strings.
- Usar `.env.example` apenas como template, sempre sem valores reais.
- Configurar secrets nas plataformas adequadas, como Vercel, Supabase e n8n.
- Revisar o histórico do Git caso algum secret seja exposto.
- Rotacionar chaves imediatamente se forem expostas por acidente.

## 8. Checklist da etapa

- [ ] Conta Supabase criada.
- [ ] Projeto Supabase `sorrisobot-ai` criado.
- [ ] Gemini API key criada.
- [ ] Conta Vercel pronta.
- [ ] Estratégia n8n definida.
- [ ] Estratégia Evolution API definida.
- [ ] `.env.example` criado.
- [ ] `.env.local` criado localmente e ignorado pelo Git.

## Decisões técnicas da Etapa 2

### n8n

A estratégia inicial será usar o n8n Cloud como ambiente principal de automação.

Essa decisão foi tomada para reduzir riscos de infraestrutura, já que o n8n Cloud fornece webhook público de forma imediata e facilita a demonstração do fluxo funcionando no vídeo final.

Durante o desenvolvimento, será usada a Test URL do Webhook node para capturar e analisar os payloads enviados pela Evolution API. Na versão final, será usada a Production URL com o workflow salvo e publicado/ativado.

A opção self-hosted será considerada apenas como evolução futura, pois exige cuidados adicionais com túnel, domínio, SSL, proxy reverso e configuração correta da variável WEBHOOK_URL.

### Evolution API

A estratégia inicial será usar a Evolution API v2 em uma instância controlada pelo projeto, executada com Docker Compose.

Durante o desenvolvimento, a API poderá ser testada localmente. Para a demonstração final, a instância deverá ficar disponível publicamente, preferencialmente via Railway ou VPS simples.

Essa decisão permite controlar a integração com WhatsApp, configurar a instância via QR Code, registrar webhooks apontando para o n8n Cloud e enviar mensagens automáticas pela API.

### Arquitetura operacional definida

WhatsApp real → Evolution API publicada → Webhook n8n Cloud → Gemini API → Supabase → Evolution API → WhatsApp → Dashboard Vercel