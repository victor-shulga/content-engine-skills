---
name: 02-profile-audit
description: Step 2 of the Content Engine flow. Audit a person LinkedIn profile against the 2026 optimization framework AND the client strategy, then propose concrete rewrites per section plus a banner design brief and a Featured-section plan. Use when the user asks to audit a LinkedIn profile, оптимізувати профіль, аудит профілю, покращити банер / Featured / хедлайн, or prepare a profile to convert visitors.
argument-hint: "<person-linkedin-url> [client]"
---

# 02 · Profile Audit — профіль як лендинг + ranking-сигнал

Другий крок Content Engine. Аудитує поточний профіль проти методички
`${CLAUDE_PLUGIN_ROOT}/reference/profile-optimization.md` (2026) **і проти стратегії клієнта**
(`🧭 {Client} · Strategy`), потім дає конкретні переписи по секціях + бриф банера + план Featured.

**Вхід:** `$ARGUMENTS` — LinkedIn-профіль людини (+ клієнт, дефолт — єдиний активний). Каденс:
раз на старті + після ребрендів/зміни позиціонування.

## Що тягнемо

1. **Поточний профіль (Apify):** `apimaestro/linkedin-profile-detail` — хедлайн, About, досвід,
   банер-URL, фото, навички; за потреби `apimaestro/linkedin-profile-posts` для top-skills/тем.
   Реюз скіла `29-linkedin-profile-audit` для механічного аудиту, якщо доступний.
2. **Стратегія клієнта (Notion):** ICP, value prop, signature concept, офер-драбина, voice,
   факти-патрони — це те, на ЩО профіль має конвертувати. Без стратегії спершу запропонуй
   запустити `content-engine:01-strategy`.

## Аудит (по 8 секціях методички)

Для кожної секції: **поточний стан → вердикт (✅/⚠️/❌) → конкретний переписаний варіант**.
Особлива увага:

- **Хедлайн:** дай 2–3 готові варіанти за формулами методички, з ICP + dream outcome зі стратегії
  і **ключовими словами теми** (Topic Authority / Interest Graph — топік має читатись).
- **About:** переписати перший абзац як хук (signature-фраза + CTA), далі структура
  «зміни ринку → проблеми ЦА → рішення → як виглядає → бенефіти». Дати повний текст, не поради.
- **Банер — design brief** (не картинка тут): 4 блоки (ICP · social proof з фактів-патронів ·
  what+for whom · dream outcome), бренд-кіт клієнта (для Viktor — Victor Shulga, білий фон + корал),
  1584×396. Передати у дизайн-крок (Figma/Canva), не генерувати в цьому скілі.
- **Featured — план:** 1–2 пункти, прив'язані до офер-драбини (безкоштовне/self-assessment →
  Audit); що саме викласти (лід-магніт / кейс / proof-скрін).
- **Навички/Рекомендації:** список 20+ навичок під топік для SEO; кому написати по ≥3 рекомендації.

⚠️ **Не радити застаріле:** Creator Mode прибрано (методичка §застаріло) — замість нього
Follow-primary + Newsletter.

## Вихід (Notion)

Сторінка **«👤 {Client} · Profile Audit»** на хабі «Content Engine»:
- таблиця-аудит 8 секцій (поточне / вердикт / переписаний варіант),
- блок **Банер-бриф** (готовий до передачі в дизайн),
- блок **Featured-план**,
- **пріоритети**: 🔴 must-fix (хедлайн/банер/About-хук) → 🟠 → 🟡,
- короткий summary користувачу + що далі.

## Definition of Done

- Усі 8 секцій оцінені; кожна з конкретним переписом (не загальні поради).
- Хедлайн і About подані готовим текстом у голосі клієнта (voice зі стратегії).
- Банер-бриф (4 блоки) і Featured-план прив'язані до стратегії/офер-драбини.
- Жодних застарілих порад (Creator Mode тощо).
- Профіль явно підсилює ОДНУ тему (Topic Authority); сторінка аудиту в Notion створена.
