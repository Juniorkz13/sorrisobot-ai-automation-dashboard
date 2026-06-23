# SorrisoBot AI

SorrisoBot AI é um projeto de atendimento automatizado via WhatsApp para a clínica odontológica fictícia **Clínica Sorriso Vivo**, integrado a um dashboard web para acompanhamento operacional das conversas, métricas e status de atendimento.

## Objetivo do teste técnico

Construir dois desafios integrados para uma vaga de Analista de IA e Automações:

1. Um agente de atendimento automatizado via WhatsApp usando n8n, Evolution API, Gemini API, memória de conversa, classificação de intents, tratamento de mensagens, envio automático de resposta e registro das conversas em banco de dados.
2. Um dashboard web funcional conectado à mesma base de dados usada pelo agente, com listagem de conversas reais, status, métricas agregadas, filtros, gráficos, atualização em tempo real e deploy público.

Nesta etapa inicial, o objetivo é apenas preparar a estrutura do repositório, a documentação base e a organização do projeto para evolução incremental.

## Visão geral da arquitetura

O projeto será organizado como um monorepo simples. O n8n será responsável pela orquestração do atendimento automatizado, recebendo eventos do WhatsApp por meio da Evolution API, chamando o Gemini API para interpretação e resposta, aplicando memória e classificação de intents, e persistindo os dados no Supabase.

O dashboard em Next.js consumirá a mesma base Supabase para exibir conversas, status e métricas em tempo real. O deploy público do dashboard será feito na Vercel.

## Stack planejada

- **n8n**: automação principal e orquestração do agente.
- **Evolution API**: integração com WhatsApp.
- **Gemini API**: modelo de IA para entendimento e geração de respostas.
- **Supabase**: banco Postgres, autenticação e realtime.
- **Next.js**: dashboard web.
- **Vercel**: deploy do dashboard.
- **GitHub**: versionamento e entrega do código.
- **Codex**: apoio principal no processo de vibe coding.

## Estrutura de pastas

```text
.
├── apps/
│   └── dashboard/
├── workflows/
│   └── n8n/
├── supabase/
│   ├── migrations/
│   └── seed/
├── infra/
│   └── evolution-api/
│       ├── docker-compose.yml
│       ├── .env.example
│       └── scripts/
├── docs/
│   ├── architecture.md
│   ├── database-schema.md
│   ├── delivery-checklist.md
│   ├── evolution-api-setup.md
│   ├── n8n-workflow-setup.md
│   ├── setup-tools.md
│   ├── vibe-coding-journal.md
│   └── video-script.md
├── prompts/
│   └── codex/
│       └── 001-project-initialization.md
├── .github/
│   └── workflows/
├── .gitignore
├── LICENSE
└── README.md
```

## Documentação

- `docs/architecture.md`: visão geral da arquitetura, fluxos principais e decisões técnicas iniciais.
- `docs/database-schema.md`: modelagem inicial do Supabase, tabelas, relações, RLS, realtime e views de métricas.
- `docs/evolution-api-setup.md`: preparação da Evolution API v2 com Docker Compose, Postgres interno, Redis interno e scripts auxiliares.
- `docs/n8n-workflow-setup.md`: documentação da Etapa 5, com workflow n8n validado ponta a ponta e problemas corrigidos.
- `docs/setup-tools.md`: preparação das ferramentas, contas necessárias, variáveis sensíveis e decisões da etapa.
- `docs/delivery-checklist.md`: checklist de entregáveis obrigatórios e diferenciais planejados.
- `docs/vibe-coding-journal.md`: registro do uso de IA durante o desenvolvimento.
- `docs/video-script.md`: roteiro inicial dos vídeos de demonstração.

## Evolution API

A Evolution API v2 será executada em Docker Compose com PostgreSQL e Redis próprios, isolados do Supabase do produto. O Supabase continuará sendo usado apenas para dados de negócio, memória, histórico, métricas e realtime do SorrisoBot AI.

A configuração inicial está em `infra/evolution-api` e o passo a passo está documentado em `docs/evolution-api-setup.md`.

## Diferenciais que serão implementados

- Memória de conversa.
- Classificação de intents.
- Fila ou buffering de mensagens.
- Tratamento de imagens.
- Tratamento de áudios.
- Integração com Google Agenda.
- RAG para respostas baseadas em conhecimento da clínica.
- Atualização em tempo real no dashboard.
- Filtros avançados.
- Gráficos e métricas agregadas.
- Análise de sentimento.
- Handoff para atendimento humano.
- Autenticação no dashboard.
- Tema claro e escuro.
- Testes automatizados.
- CI/CD.
- Vibe Coding Journal documentando o uso de IA no projeto.

## Status atual do projeto

Projeto em fase de inicialização.

Nesta etapa foram criadas apenas a estrutura inicial do monorepo e a documentação base. Ainda não há dashboard implementado, workflow n8n funcional, configuração do Supabase, deploy público ou integrações reais com APIs externas.

## Execução local futura

No futuro, o projeto deverá ser executado localmente com etapas semelhantes a:

```bash
# Instalar dependências do dashboard
cd apps/dashboard
npm install

# Executar o dashboard localmente
npm run dev
```

Também serão documentados os passos para configurar Supabase, importar o workflow do n8n, conectar Evolution API e configurar as credenciais necessárias.

## Variáveis sensíveis

Credenciais, tokens, chaves de API, URLs privadas, senhas e arquivos `.env` não devem ser versionados. Qualquer variável sensível deverá ser configurada localmente ou nos ambientes seguros das plataformas utilizadas, como Vercel, Supabase e n8n.

## Vibe Coding Journal

Este projeto utilizará um registro contínuo do processo de desenvolvimento com IA. O objetivo é documentar prompts usados, decisões técnicas, resultados obtidos, acertos da IA, falhas encontradas e correções manuais realizadas.

O diário principal está disponível em `docs/vibe-coding-journal.md`.

### Banco de dados

O schema inicial do Supabase está documentado em `docs/database-schema.md` e versionado em `supabase/migrations/202606220001_initial_schema.sql`.

O banco foi modelado para armazenar contatos, conversas, mensagens, eventos, fila de processamento, agendamentos, base de conhecimento, configurações do agente e views de métricas para o dashboard.
