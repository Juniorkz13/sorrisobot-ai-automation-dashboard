create or replace function public.get_or_create_open_conversation(
  p_contact_id uuid,
  p_instance text default 'sorrisobot'
)
returns table (
  id uuid,
  contact_id uuid,
  status conversation_status,
  current_intent intent_type,
  sentiment sentiment_type,
  created_at timestamptz,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_conversation_id uuid;
begin
  select c.id
  into v_conversation_id
  from public.conversations c
  where c.contact_id = p_contact_id
    and c.status in (
      'em_andamento',
      'agendamento_pendente',
      'orcamento_enviado',
      'aguardando_humano'
    )
  order by c.last_message_at desc nulls last, c.created_at desc
  limit 1;

  if v_conversation_id is null then
    insert into public.conversations (
      contact_id,
      channel,
      status,
      current_intent,
      sentiment,
      last_message_at,
      metadata
    )
    values (
      p_contact_id,
      'whatsapp',
      'em_andamento',
      'desconhecida',
      'neutro',
      now(),
      jsonb_build_object(
        'created_by', 'n8n',
        'instance', p_instance
      )
    )
    returning conversations.id into v_conversation_id;

    insert into public.conversation_events (
      conversation_id,
      event_type,
      description,
      metadata
    )
    values (
      v_conversation_id,
      'conversation_created',
      'Conversa criada automaticamente pelo workflow n8n.',
      jsonb_build_object(
        'source', 'n8n',
        'instance', p_instance
      )
    );
  end if;

  return query
  select
    c.id,
    c.contact_id,
    c.status,
    c.current_intent,
    c.sentiment,
    c.created_at,
    c.updated_at
  from public.conversations c
  where c.id = v_conversation_id;
end;
$$;

grant execute on function public.get_or_create_open_conversation(uuid, text) to authenticated;