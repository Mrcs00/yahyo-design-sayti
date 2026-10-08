-- =====================================================
-- YAHYO.DESIGN — kategoriyalarni admin paneldan boshqarish (3-qadam)
-- Supabase > SQL Editor > New query > shu faylni to'liq qo'yib "Run" bosing.
-- Mavjud rasmlarga tegmaydi. Qayta ishga tushirsangiz ham xavfsiz.
-- =====================================================

-- 1) Kategoriyalar jadvali: hamma o'qiy oladi, faqat admin qo'sha/o'chira oladi
create table if not exists public.site_categories (
  id serial primary key,
  name text not null unique check (char_length(name) between 1 and 60),
  created_at timestamptz not null default now()
);
alter table public.site_categories enable row level security;

drop policy if exists "categories_read" on public.site_categories;
create policy "categories_read" on public.site_categories
  for select using (true);

drop policy if exists "categories_insert_admin" on public.site_categories;
create policy "categories_insert_admin" on public.site_categories
  for insert to authenticated with check (public.is_admin());

drop policy if exists "categories_delete_admin" on public.site_categories;
create policy "categories_delete_admin" on public.site_categories
  for delete to authenticated using (public.is_admin());

-- 2) Hozirgi 5 ta kategoriya (raqamlari saytdagi eski raqamlar bilan bir xil)
insert into public.site_categories (id, name) values
  (1, 'Interyer'), (2, 'Eksteryer'), (3, 'Landshaft'), (4, 'Ofis'), (5, 'Yotoqxona')
on conflict (id) do nothing;

-- Yangi kategoriyalar 6-raqamdan boshlansin
select setval('public.site_categories_id_seq', (select max(id) from public.site_categories));

-- 3) Rasmlar endi shu jadvaldagi kategoriyaga bog'lanadi.
--    Eski "faqat 1-5" cheklovi olib tashlanadi. Rasmi bor kategoriyani
--    bazaning o'zi ham o'chirishga yo'l qo'ymaydi.
alter table public.gallery_items drop constraint if exists gallery_items_cat_check;
alter table public.gallery_items drop constraint if exists gallery_items_cat_fkey;
alter table public.gallery_items
  add constraint gallery_items_cat_fkey
  foreign key (cat) references public.site_categories(id) on delete restrict;

-- Tekshirish: 5 ta qator chiqishi kerak
select id, name from public.site_categories order by id;
