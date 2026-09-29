# Admin panelni sozlash (Supabase)

Bir marta qilinadi, taxminan 10 daqiqa. Tugma nomlari Supabase yangilanganda biroz farq qilishi mumkin.

## 1. Loyiha yaratish
1. https://supabase.com da ro'yxatdan o'ting.
2. **New project** bosing. Nomi: `yahyo-design`. Database parolini o'ylab topib, **o'zingiz saqlab qo'ying** (hech kimga bermang).
3. Region: Yevropaga yaqinini tanlang. Loyiha tayyor bo'lishini kuting.

## 2. Jadvallarni yaratish
1. Chap menyudan **SQL Editor** > **New query**.
2. `1-setup.sql` faylining hammasini nusxalab qo'ying va **Run** bosing. "Success" chiqishi kerak.

## 3. Admin hisob ochish
1. Chap menyu: **Authentication** > **Users** > **Add user** > **Create new user**.
2. O'zingizning email va parolingizni kiriting, **Auto Confirm User** ni belgilang. Parolni o'zingiz saqlang: admin panelga shu bilan kirasiz.
3. **SQL Editor** > yangi query. `2-admin-qoshish.sql` ichidagi `AKAMNING-EMAILI@example.com` ni o'sha emailga almashtirib **Run** bosing. Pastda emailingiz chiqsa, tayyor.

## 4. Begona ro'yxatdan o'tishni o'chirish
**Authentication** > **Sign In / Providers** (yoki Settings) bo'limida **Allow new users to sign up** ni **o'chiring**. Shunda faqat siz ochgan hisob kira oladi.

## 5. Ikki kalitni saytga berish
**Project Settings** > **API** (yoki **API Keys**) bo'limidan ikkitasini nusxalang:
- **Project URL** (`https://....supabase.co`)
- **anon** yoki **publishable** kalit

Bu ikkisi ochiq kalit, saytning kodida turadi, ularni yuborish xavfsiz.
**`service_role` / `secret` kalitni va database parolni hech kimga bermang.**

`index.html` faylida `SUPABASE_URL` va `SUPABASE_ANON_KEY` qatorlarini toping (Ctrl+F) va `REPLACE_ME` o'rniga shu qiymatlarni qo'ying. Keyin GitHub'ga push qiling.

## 6. Ishlatish
Saytning eng pastidagi **Admin** tugmasini bosing (yoki manzil oxiriga `#admin` qo'shing), email va parol bilan kiring.
- **Rasmlar:** yangi rasm yuklash, kategoriyasini o'zgartirish, o'chirish. Saytdagi hozirgi yotoqxona rasmlarini boshqarish uchun **"Eski rasmlarni bazaga ko'chirish"** tugmasini bir marta bosing.
- **Narxlar:** uchta tarifning narxini (faqat raqam) o'zgartirish.

## Eslatma
Supabase bepul loyihasi bir hafta umuman ishlatilmasa to'xtatilishi mumkin. Sayt ochilib turgan bo'lsa bu kam uchraydi. To'xtab qolsa, Supabase paneldan **Restore** bosiladi.
