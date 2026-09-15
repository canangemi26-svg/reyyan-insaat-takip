-- Reyyan İnşaat Takip — ortak kullanım veritabanı
create table if not exists public.company_state (
  id text primary key,
  state jsonb not null default '{}'::jsonb,
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now()
);

alter table public.company_state enable row level security;
grant select, insert, update on public.company_state to authenticated;

drop policy if exists "authenticated users can read company state" on public.company_state;
drop policy if exists "authenticated users can insert company state" on public.company_state;
drop policy if exists "authenticated users can update company state" on public.company_state;

create policy "authenticated users can read company state"
on public.company_state for select to authenticated using (true);

create policy "authenticated users can insert company state"
on public.company_state for insert to authenticated with check (true);

create policy "authenticated users can update company state"
on public.company_state for update to authenticated using (true) with check (true);

do $$
begin
  alter publication supabase_realtime add table public.company_state;
exception when duplicate_object then
  null;
end $$;
