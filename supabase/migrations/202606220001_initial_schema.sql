-- SorrisoBot AI - schema inicial
-- Projeto: atendimento odontologico automatizado com WhatsApp, n8n, Gemini e Supabase.
-- Esta migration cria somente estrutura, configuracoes iniciais e views agregadas.
-- Nao sao inseridas conversas, mensagens ou dados falsos de dashboard.

create extension if not exists pgcrypto;

-- Tipos enumerados do dominio do atendimento.
do $$
begin
  if not exists (select 1 from pg_type where typname = 'conversation_status') then
    create type conversation_status as enum (
      'em_andamento',
      'aguardando_humano',
      'agendamento_pendente',
      'agendado',
      'orcamento_enviado',
      'encerrada',
      'erro'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'message_direction') then
    create type message_direction as enum (
      'inbound',
      'outbound',
      'system'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'message_type') then
    create type message_type as enum (
      'text',
      'image',
      'audio',
      'document',
      'video',
      'sticker',
      'unknown'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'intent_type') then
    create type intent_type as enum (
      'saudacao',
      'duvida',
      'orcamento',
      'agendamento',
      'emergencia',
      'humano',
      'encerramento',
      'imagem',
      'audio',
      'fora_de_escopo',
      'desconhecida'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'sentiment_type') then
    create type sentiment_type as enum (
      'positivo',
      'neutro',
      'negativo',
      'urgente'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'queue_status') then
    create type queue_status as enum (
      'pending',
      'processing',
      'done',
      'failed'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'appointment_status') then
    create type appointment_status as enum (
      'solicitado',
      'confirmado',
      'reagendado',
      'cancelado',
      'concluido',
      'erro'
    );
  end if;
end
$$;

create table if not exists contacts (
  id uuid primary key default gen_random_uuid(),
  phone_e164 text unique not null,
  whatsapp_jid text,
  name text,
  push_name text,
  first_seen_at timestamptz default now(),
  last_seen_at timestamptz default now(),
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists conversations (
  id uuid primary key default gen_random_uuid(),
  contact_id uuid references contacts(id),
  channel text default 'whatsapp',
  status conversation_status default 'em_andamento',
  current_intent intent_type default 'desconhecida',
  sentiment sentiment_type default 'neutro',
  priority integer default 0,
  human_handoff_required boolean default false,
  assigned_to text,
  summary text,
  message_count integer default 0,
  inbound_count integer default 0,
  outbound_count integer default 0,
  last_message_at timestamptz,
  started_at timestamptz default now(),
  closed_at timestamptz,
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid references conversations(id) on delete cascade,
  contact_id uuid references contacts(id),
  direction message_direction not null,
  type message_type default 'text',
  intent intent_type default 'desconhecida',
  sentiment sentiment_type default 'neutro',
  provider text default 'evolution_api',
  provider_message_id text,
  content text,
  media_url text,
  media_mime_type text,
  transcription text,
  ai_model text,
  prompt_tokens integer,
  completion_tokens integer,
  total_tokens integer,
  response_time_ms integer,
  raw_payload jsonb default '{}'::jsonb,
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now()
);

create table if not exists conversation_events (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid references conversations(id) on delete cascade,
  event_type text not null,
  description text,
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now()
);

create table if not exists message_queue (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid references conversations(id) on delete cascade,
  contact_id uuid references contacts(id),
  phone_e164 text,
  batch_key text,
  content text,
  raw_payload jsonb default '{}'::jsonb,
  status queue_status default 'pending',
  available_at timestamptz default now(),
  processed_at timestamptz,
  error_message text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists appointments (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid references conversations(id) on delete set null,
  contact_id uuid references contacts(id) on delete set null,
  google_event_id text,
  patient_name text,
  patient_phone text,
  requested_date date,
  scheduled_start_at timestamptz,
  scheduled_end_at timestamptz,
  status appointment_status default 'solicitado',
  notes text,
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists knowledge_documents (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  content text not null,
  source_type text default 'manual',
  source_url text,
  tags text[] default '{}'::text[],
  active boolean default true,
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists agent_settings (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  value jsonb not null default '{}'::jsonb,
  description text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Indices para consultas do agente, dashboard, filtros e metricas.
create index if not exists idx_contacts_phone_e164 on contacts(phone_e164);
create index if not exists idx_conversations_contact_id on conversations(contact_id);
create index if not exists idx_conversations_status on conversations(status);
create index if not exists idx_conversations_current_intent on conversations(current_intent);
create index if not exists idx_conversations_last_message_at on conversations(last_message_at);
create index if not exists idx_messages_conversation_id on messages(conversation_id);
create index if not exists idx_messages_contact_id on messages(contact_id);
create index if not exists idx_messages_created_at on messages(created_at);
create index if not exists idx_messages_intent on messages(intent);
create index if not exists idx_messages_sentiment on messages(sentiment);
create index if not exists idx_conversation_events_conversation_id on conversation_events(conversation_id);
create index if not exists idx_message_queue_status on message_queue(status);
create index if not exists idx_message_queue_available_at on message_queue(available_at);
create index if not exists idx_appointments_status on appointments(status);
create index if not exists idx_appointments_scheduled_start_at on appointments(scheduled_start_at);
create index if not exists idx_knowledge_documents_active on knowledge_documents(active);

-- Atualiza automaticamente colunas updated_at.
create or replace function update_updated_at_column()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_contacts_updated_at on contacts;
create trigger trg_contacts_updated_at
before update on contacts
for each row
execute function update_updated_at_column();

drop trigger if exists trg_conversations_updated_at on conversations;
create trigger trg_conversations_updated_at
before update on conversations
for each row
execute function update_updated_at_column();

drop trigger if exists trg_message_queue_updated_at on message_queue;
create trigger trg_message_queue_updated_at
before update on message_queue
for each row
execute function update_updated_at_column();

drop trigger if exists trg_appointments_updated_at on appointments;
create trigger trg_appointments_updated_at
before update on appointments
for each row
execute function update_updated_at_column();

drop trigger if exists trg_knowledge_documents_updated_at on knowledge_documents;
create trigger trg_knowledge_documents_updated_at
before update on knowledge_documents
for each row
execute function update_updated_at_column();

drop trigger if exists trg_agent_settings_updated_at on agent_settings;
create trigger trg_agent_settings_updated_at
before update on agent_settings
for each row
execute function update_updated_at_column();

-- Mantem a conversa agregada quando uma mensagem e registrada.
create or replace function update_conversation_after_message_insert()
returns trigger
language plpgsql
as $$
begin
  update conversations
  set
    message_count = coalesce(message_count, 0) + 1,
    inbound_count = coalesce(inbound_count, 0) + case when new.direction = 'inbound' then 1 else 0 end,
    outbound_count = coalesce(outbound_count, 0) + case when new.direction = 'outbound' then 1 else 0 end,
    last_message_at = new.created_at,
    current_intent = case
      when new.intent <> 'desconhecida' then new.intent
      else current_intent
    end,
    sentiment = case
      when new.sentiment <> 'neutro' then new.sentiment
      else sentiment
    end,
    updated_at = now()
  where id = new.conversation_id;

  return new;
end;
$$;

drop trigger if exists trg_messages_update_conversation on messages;
create trigger trg_messages_update_conversation
after insert on messages
for each row
execute function update_conversation_after_message_insert();

-- Views para o dashboard. Elas agregam dados reais gravados pelo agente.
create or replace view v_dashboard_overview as
select
  (select count(*) from conversations) as total_conversations,
  (select count(*) from messages) as total_messages,
  (select count(*) from conversations where status in ('em_andamento', 'agendamento_pendente', 'orcamento_enviado')) as active_conversations,
  (select count(*) from conversations where status = 'aguardando_humano') as waiting_human,
  (select count(*) from conversations where status = 'encerrada') as closed_conversations,
  (
    select count(*)
    from appointments
    where status in ('confirmado', 'reagendado')
      and scheduled_start_at is not null
  ) as scheduled_appointments,
  (
    select avg(response_time_ms)::integer
    from messages
    where response_time_ms is not null
  ) as avg_response_time_ms;

create or replace view v_conversations_by_day as
select
  date_trunc('day', c.created_at)::date as day,
  count(distinct c.id) as total_conversations,
  count(m.id) as total_messages
from conversations c
left join messages m on m.conversation_id = c.id
group by 1
order by 1 desc;

create or replace view v_conversations_by_status as
select
  status,
  count(*) as total
from conversations
group by status
order by total desc;

create or replace view v_messages_by_intent as
select
  intent,
  count(*) as total
from messages
group by intent
order by total desc;

-- Row Level Security: leitura autenticada, sem acesso publico anonimo.
alter table contacts enable row level security;
alter table conversations enable row level security;
alter table messages enable row level security;
alter table conversation_events enable row level security;
alter table message_queue enable row level security;
alter table appointments enable row level security;
alter table knowledge_documents enable row level security;
alter table agent_settings enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'contacts' and policyname = 'authenticated_select_contacts'
  ) then
    create policy authenticated_select_contacts
      on contacts for select
      to authenticated
      using (true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'conversations' and policyname = 'authenticated_select_conversations'
  ) then
    create policy authenticated_select_conversations
      on conversations for select
      to authenticated
      using (true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'messages' and policyname = 'authenticated_select_messages'
  ) then
    create policy authenticated_select_messages
      on messages for select
      to authenticated
      using (true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'conversation_events' and policyname = 'authenticated_select_conversation_events'
  ) then
    create policy authenticated_select_conversation_events
      on conversation_events for select
      to authenticated
      using (true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'appointments' and policyname = 'authenticated_select_appointments'
  ) then
    create policy authenticated_select_appointments
      on appointments for select
      to authenticated
      using (true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'knowledge_documents' and policyname = 'authenticated_select_knowledge_documents'
  ) then
    create policy authenticated_select_knowledge_documents
      on knowledge_documents for select
      to authenticated
      using (true);
  end if;
end
$$;

-- Supabase Realtime: habilita tabelas principais se a publicacao existir.
-- Em ambientes onde a publicacao nao estiver disponivel, habilitar manualmente pelo painel do Supabase.
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = 'conversations'
    ) then
      alter publication supabase_realtime add table public.conversations;
    end if;

    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = 'messages'
    ) then
      alter publication supabase_realtime add table public.messages;
    end if;

    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = 'conversation_events'
    ) then
      alter publication supabase_realtime add table public.conversation_events;
    end if;
  end if;
end
$$;

-- Configuracoes iniciais do agente. Nao representam dados de conversa.
insert into agent_settings (key, value, description)
values
  (
    'business_name',
    to_jsonb('Clínica Sorriso Vivo'::text),
    'Nome publico da clinica ficticia usada no teste tecnico.'
  ),
  (
    'agent_name',
    to_jsonb('SorrisoBot AI'::text),
    'Nome do agente de atendimento automatizado.'
  ),
  (
    'business_hours',
    '{
      "timezone": "America/Sao_Paulo",
      "monday": {"open": "08:00", "close": "18:00"},
      "tuesday": {"open": "08:00", "close": "18:00"},
      "wednesday": {"open": "08:00", "close": "18:00"},
      "thursday": {"open": "08:00", "close": "18:00"},
      "friday": {"open": "08:00", "close": "18:00"},
      "saturday": {"open": "08:00", "close": "12:00"},
      "sunday": null
    }'::jsonb,
    'Horario de atendimento planejado para orientar respostas do agente.'
  ),
  (
    'default_handoff_message',
    to_jsonb('Vou encaminhar seu atendimento para uma pessoa da equipe da Clínica Sorriso Vivo.'::text),
    'Mensagem padrao para transferencia ao atendimento humano.'
  ),
  (
    'default_out_of_scope_message',
    to_jsonb('Posso ajudar com informações sobre atendimento odontológico, agendamentos e dúvidas da Clínica Sorriso Vivo.'::text),
    'Mensagem padrao para assuntos fora do escopo do agente.'
  )
on conflict (key) do update
set
  value = excluded.value,
  description = excluded.description,
  updated_at = now();
