-- =====================================================
-- YAHYO.DESIGN — admin qo'shish (2-qadam)
-- AVVAL Authentication > Users bo'limida o'zingizga foydalanuvchi yarating
-- (Add user > Create new user, "Auto Confirm User" belgilangan holda).
-- KEYIN shu yerdagi email'ni o'zingiznikiga almashtirib "Run" bosing.
-- =====================================================
insert into public.admin_users (user_id)
select id from auth.users where email = 'AKAMNING-EMAILI@example.com'
on conflict do nothing;

-- Tekshirish: 1 ta qator chiqishi kerak
select u.email from public.admin_users a join auth.users u on u.id = a.user_id;
