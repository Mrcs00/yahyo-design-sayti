-- =====================================================
-- YAHYO.DESIGN — eski yotoqxona rasmlarini bitta loyihaga birlashtirish (ixtiyoriy)
--
-- FAQAT admin paneldagi "Eski rasmlarni bazaga ko'chirish" tugmasi ALLAQACHON
-- bosilgan bo'lsa ishga tushiring. Tugma bosilmagan bo'lsa kerak emas
-- (yangi kodda tugma bosilganda o'zi to'g'ri ko'chiradi).
--
-- Nima qiladi:
--  1) Ko'chirilgan eski rasmlar teskari tartibda turgan bo'lsa, tartibini to'g'rilaydi
--  2) Ularning hammasiga bitta nom ("Yotoq xonasi") beradi, shunda saytda
--     bitta loyiha (bitta kartochka) bo'ladi
-- Qayta ishga tushirsangiz ham xavfsiz.
-- Supabase > SQL Editor > New query > shu faylni qo'yib "Run" bosing.
-- =====================================================
do $$
declare
  titles text[] := array[
    'Yotoq xonasi — dam olish burchagi',
    'Yotoq xonasi — shkaf zonasi',
    'Yotoq xonasi — to''shak tafsilotlari',
    'Yotoq xonasi — umumiy ko''rinish',
    'Yotoq xonasi — kengaytirilgan zona',
    'Yotoq xonasi — old tomondan ko''rinish',
    'Yotoq xonasi — kiyim shkafi',
    'Yotoq xonasi — televizor zonasi',
    'Yotoq xonasi — TV devor paneli'
  ];
  n int;
  first_at timestamptz;
  last_at timestamptz;
begin
  select count(*) into n from public.gallery_items where title = any(titles);
  if n = 0 then
    raise notice 'Eski yotoqxona rasmlari topilmadi, hech narsa o''zgartirilmadi.';
    return;
  end if;

  -- ro'yxatdagi eng birinchi va eng oxirgi rasmning yuklangan vaqti
  select created_at into first_at from public.gallery_items
    where title = any(titles) order by array_position(titles, title) asc, created_at asc limit 1;
  select created_at into last_at from public.gallery_items
    where title = any(titles) order by array_position(titles, title) desc, created_at desc limit 1;

  -- birinchi rasm keyin yuklangan bo'lsa: tartib teskari, vaqtlarni almashtiramiz
  if first_at > last_at then
    with r as (
      select id, created_at,
             row_number() over (order by created_at) as rn,
             count(*) over () as cnt
      from public.gallery_items where title = any(titles)
    ),
    m as (
      select a.id, b.created_at as new_at
      from r a join r b on b.rn = a.cnt - a.rn + 1
    )
    update public.gallery_items g set created_at = m.new_at from m where g.id = m.id;
  end if;

  update public.gallery_items set title = 'Yotoq xonasi' where title = any(titles);
end $$;

-- Tekshirish: hammasi bir xil nomda, tartib bilan chiqishi kerak
select title, cat, created_at from public.gallery_items order by created_at;
