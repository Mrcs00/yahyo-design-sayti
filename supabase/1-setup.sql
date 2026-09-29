-- =====================================================
-- YAHYO.DESIGN — Supabase sozlash (1-qadam)
-- Supabase > SQL Editor > New query > shu faylni to'liq qo'yib "Run" bosing.
-- Qayta ishga tushirsangiz ham xavfsiz (takroriy xato bermaydi).
-- =====================================================

-- 1) Adminlar ro'yxati. RLS yoqilgan va hech qanday siyosat yo'q,
--    ya'ni bu jadvalni brauzerdan hech kim o'qiy yoki o'zgartira olmaydi.
create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.admin_users enable row level security;

-- Joriy foydalanuvchi admin ekanini tekshiradi
create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (select 1 from public.admin_users where user_id = auth.uid());
$$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to anon, authenticated;

-- 2) Galereya rasmlari
create table if not exists public.gallery_items (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 120),
  cat smallint not null check (cat between 1 and 5),
  image_path text not null,
  image_url text not null,
  created_at timestamptz not null default now()
);
alter table public.gallery_items enable row level security;

drop policy if exists "gallery_read" on public.gallery_items;
create policy "gallery_read" on public.gallery_items
  for select using (true);

drop policy if exists "gallery_insert_admin" on public.gallery_items;
create policy "gallery_insert_admin" on public.gallery_items
  for insert to authenticated with check (public.is_admin());

drop policy if exists "gallery_update_admin" on public.gallery_items;
create policy "gallery_update_admin" on public.gallery_items
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "gallery_delete_admin" on public.gallery_items;
create policy "gallery_delete_admin" on public.gallery_items
  for delete to authenticated using (public.is_admin());

-- 3) Narxlar (faqat 3 ta tarif, faqat raqam)
create table if not exists public.site_prices (
  plan_key text primary key check (plan_key in ('standard','premium','vip')),
  value numeric(10,2) not null check (value >= 0 and value <= 100000),
  updated_at timestamptz not null default now()
);
alter table public.site_prices enable row level security;

insert into public.site_prices (plan_key, value) values
  ('standard', 5), ('premium', 7), ('vip', 12)
on conflict (plan_key) do nothing;

drop policy if exists "prices_read" on public.site_prices;
create policy "prices_read" on public.site_prices
  for select using (true);

drop policy if exists "prices_insert_admin" on public.site_prices;
create policy "prices_insert_admin" on public.site_prices
  for insert to authenticated with check (public.is_admin());

drop policy if exists "prices_update_admin" on public.site_prices;
create policy "prices_update_admin" on public.site_prices
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- 4) Kichik belgilar (eski rasmlar ko'chirilganini eslab qolish uchun)
create table if not exists public.site_flags (
  key text primary key,
  value text not null
);
alter table public.site_flags enable row level security;

drop policy if exists "flags_read" on public.site_flags;
create policy "flags_read" on public.site_flags
  for select using (true);

drop policy if exists "flags_insert_admin" on public.site_flags;
create policy "flags_insert_admin" on public.site_flags
  for insert to authenticated with check (public.is_admin());

drop policy if exists "flags_update_admin" on public.site_flags;
create policy "flags_update_admin" on public.site_flags
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- 5) Rasmlar uchun ochiq "gallery" papkasi (bucket): faqat rasm, 5 MB gacha
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('gallery', 'gallery', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update
  set public = true,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "gallery_files_insert_admin" on storage.objects;
create policy "gallery_files_insert_admin" on storage.objects
  for insert to authenticated with check (bucket_id = 'gallery' and public.is_admin());

drop policy if exists "gallery_files_update_admin" on storage.objects;
create policy "gallery_files_update_admin" on storage.objects
  for update to authenticated using (bucket_id = 'gallery' and public.is_admin())
  with check (bucket_id = 'gallery' and public.is_admin());

drop policy if exists "gallery_files_delete_admin" on storage.objects;
create policy "gallery_files_delete_admin" on storage.objects
  for delete to authenticated using (bucket_id = 'gallery' and public.is_admin());
