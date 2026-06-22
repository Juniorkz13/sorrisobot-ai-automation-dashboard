# Prompt 001: Inicialização do Projeto

```text
Você é um arquiteto de software sênior ajudando a iniciar um projeto real para um teste técnico de vaga de Analista de IA e Automações.

Contexto do teste técnico:

Preciso construir dois desafios integrados:

1. Um agente de atendimento automatizado via WhatsApp usando n8n, Evolution API, um modelo de IA, memória de conversa, classificação de intents, tratamento de mensagens, envio automático de resposta e registro das conversas em banco de dados.

2. Um dashboard web funcional que conecta na mesma base de dados usada pelo agente, lista conversas reais com status, mostra métricas agregadas, filtros, gráficos, atualização em tempo real e deploy público.

Stack planejada:

* n8n para automação principal
* Evolution API para WhatsApp
* Gemini API como modelo de IA
* Supabase como banco Postgres, autenticação e realtime
* Next.js para o dashboard
* Vercel para deploy
* GitHub para versionamento
* Codex como ferramenta principal de vibe coding

Nicho escolhido:

Clínica odontológica fictícia chamada “Clínica Sorriso Vivo”.

Nome do produto:

SorrisoBot AI.

Objetivo desta primeira tarefa:

Criar apenas a estrutura inicial do repositório, documentação base e organização do projeto. Não implemente ainda o dashboard, não configure Supabase, não crie workflow n8n funcional e não adicione dependências desnecessárias nesta etapa.

Crie uma estrutura de monorepo com:

* apps/dashboard
* workflows/n8n
* supabase/migrations
* supabase/seed
* docs
* prompts/codex
* .github/workflows

Crie também os seguintes arquivos iniciais:

1. README.md

O README deve conter:

* Nome do projeto
* Descrição curta
* Objetivo do teste técnico
* Visão geral da arquitetura
* Stack planejada
* Estrutura de pastas
* Diferenciais que serão implementados
* Status atual do projeto
* Como o projeto será executado localmente no futuro
* Aviso de que as variáveis sensíveis não devem ser versionadas
* Seção inicial chamada “Vibe Coding Journal”

2. docs/architecture.md

Deve documentar:

* Visão geral da arquitetura
* Fluxo do agente WhatsApp
* Fluxo do dashboard
* Componentes principais
* Decisões técnicas iniciais
* Diagrama textual usando Mermaid

3. docs/delivery-checklist.md

Deve conter uma checklist completa dos entregáveis dos dois desafios:

* JSON exportado do workflow n8n
* Vídeo do agente funcionando
* Link do GitHub
* URL pública do dashboard
* Vídeo do dashboard funcionando integrado ao agente
* Print ou link do histórico de conversa com IA
* README
* Deploy
* Dados reais, sem mock estático

Também inclua os diferenciais:

* Memória
* Intents
* Fila/buffering
* Imagens
* Áudios
* Google Agenda
* RAG
* Realtime
* Filtros
* Gráficos
* Sentimento
* Handoff humano
* Autenticação
* Tema claro/escuro
* Testes
* CI/CD
* Vibe Coding Journal

4. docs/vibe-coding-journal.md

Deve conter uma estrutura para registrar:

* Data
* Ferramenta usada
* Prompt utilizado
* Resultado obtido
* Onde a IA acertou
* Onde a IA falhou
* Correções manuais feitas
* Decisão técnica tomada

5. docs/video-script.md

Deve conter um roteiro inicial para dois vídeos de no máximo 5 minutos:

* Vídeo do agente n8n + WhatsApp
* Vídeo do dashboard integrado

6. prompts/codex/001-project-initialization.md

Salve este próprio prompt como o primeiro prompt documentado do projeto.

7. .gitignore

Inclua ignores adequados para:

* Node.js
* Next.js
* Supabase local
* arquivos .env
* logs
* arquivos temporários do sistema
* builds
* coverage

8. LICENSE

Use MIT License com ano atual e autor como “Júnior Kz”.

Regras importantes:

* Não crie arquivos com secrets reais.
* Não invente URLs de deploy.
* Não crie dados mockados nesta etapa.
* Não implemente funcionalidades ainda.
* Priorize documentação clara, estrutura organizada e linguagem profissional.
* Todo o conteúdo deve estar em português brasileiro.
* O projeto deve parecer profissional e preparado para evolução incremental.
```
