# Roteiro dos Vídeos

Os vídeos finais devem ter no máximo 5 minutos cada, com foco em demonstrar funcionamento real, integração entre componentes e clareza técnica.

## Vídeo 1: agente n8n + WhatsApp

### Objetivo

Demonstrar o agente automatizado recebendo uma mensagem pelo WhatsApp, processando o atendimento no n8n, usando IA e registrando a conversa no banco.

### Roteiro sugerido

1. Apresentar rapidamente o SorrisoBot AI e a Clínica Sorriso Vivo.
2. Mostrar o workflow principal no n8n.
3. Explicar os blocos principais do fluxo: webhook, tratamento da mensagem, memória, intent, IA, registro no banco e resposta via WhatsApp.
4. Enviar uma mensagem real pelo WhatsApp.
5. Mostrar a execução do workflow no n8n.
6. Exibir a resposta automática chegando no WhatsApp.
7. Mostrar o registro da conversa e das mensagens no Supabase.
8. Encerrar destacando os diferenciais implementados no agente.

### Pontos que devem aparecer

- Mensagem real no WhatsApp.
- Execução real no n8n.
- Chamada ao modelo de IA.
- Registro no banco.
- Resposta automática enviada ao paciente.

## Vídeo 2: dashboard integrado

### Objetivo

Demonstrar o dashboard web consumindo os dados reais gerados pelo agente, com métricas, filtros, gráficos e atualização em tempo real.

### Roteiro sugerido

1. Abrir a URL pública do dashboard.
2. Apresentar a visão geral com métricas principais.
3. Mostrar a lista de conversas reais.
4. Usar filtros para localizar conversas por status, intent ou período.
5. Abrir uma conversa e mostrar o histórico de mensagens.
6. Enviar uma nova mensagem pelo WhatsApp.
7. Demonstrar a atualização do dashboard refletindo o novo dado.
8. Mostrar gráficos e indicadores agregados.
9. Encerrar explicando como o dashboard usa a mesma base do agente.

### Pontos que devem aparecer

- URL pública do dashboard.
- Dados reais, sem mock estático.
- Integração com a base usada pelo agente.
- Atualização em tempo real.
- Métricas, filtros e gráficos.
