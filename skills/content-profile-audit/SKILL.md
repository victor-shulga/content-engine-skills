---
name: content-profile-audit
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
   запустити `content-engine:content-linkedin-strategy`.

## Аудит (по 8 секціях методички)

Для кожної секції: **поточний стан → вердикт (✅/⚠️/❌) → конкретний переписаний варіант**.
Особлива увага:

- **Хедлайн:** дай 2–3 готові варіанти за формулами методички, з ICP + dream outcome зі стратегії
  і **ключовими словами теми** (Topic Authority / Interest Graph — топік має читатись).
- **About:** переписати перший абзац як хук (signature-фраза + CTA), далі структура
  «зміни ринку → проблеми ЦА → рішення → як виглядає → бенефіти». Дати повний текст, не поради.
- **Банер — design brief** (не картинка тут): 4 блоки (ICP · social proof з фактів-патронів ·
  what+for whom · dream outcome), бренд-кіт клієнта (для Viktor — його персональний бренд, білий фон + корал),
  1584×396. Передати у дизайн-крок (Figma/Canva), не генерувати в цьому скілі.
- **Featured — план:** 1–2 пункти, прив'язані до офер-драбини (безкоштовне/self-assessment →
  Audit); що саме викласти (лід-магніт / кейс / proof-скрін).
- **Навички/Рекомендації:** список 20+ навичок під топік для SEO; кому написати по ≥3 рекомендації.

⚠️ **Не радити застаріле:** Creator Mode прибрано (методичка §застаріло) — замість нього
Follow-primary + Newsletter.

## Terms and plain-language output

<!-- glossary:start terms=topic-authority,dream-outcome,signature-concept,social-proof,offer-ladder,follow-primary,fact-cartridges,free-hook,voice-profile -->
Rules for every document a client or their team will read (review, roast, canvas, offer cards, instruction):

1. **Open with «Словник цього документа»**: only the terms that actually appear in it, at most 10, each as «термін: що це простими словами». Like the definitions section of a contract.
2. **No internal codes or letter scales in the text** (A/B/C, D L T E, BLEND numbers without words, Own/Shared/Generic, Z1.4, GATE 2.5, T1–T6). Write the meaning instead: «є цифра з клієнтом», not «A».
3. **Use the plain form from the table below.** English stays only for tool names and for copy that ships in English (promises, hooks, subject lines). If the document is in another language, translate the plain form, never the internal term.
4. **Do not score what cannot exist yet.** A block that depends on work not done (signal catalog, case studies, a previous step) gets «пропущено: спершу потрібно <що саме>», not a score.
5. **Every section of a review opens with one concrete action** («до наступного дзвінка: …»), then at most five lines of why. No paragraph that only restates the framework.


| Internal term (this skill) | Write for the reader | What it means |
|---|---|---|
| Topic Authority, Interest Graph, topic cluster | впізнавана тема автора | LinkedIn показує пости тим, кому цікава тема, тому профіль і пости мають тримати одну тему, яку легко зчитати. |
| dream outcome | бажаний результат клієнта | як виглядає ситуація клієнта, коли проблему вирішено, його ж словами |
| signature, signature concept | фірмова думка автора | Одна впізнавана ідея чи фраза, з якою автора асоціюють; вона повторюється в профілі й постах. |
| social proof | докази від інших | Цифри клієнтів, відгуки, логотипи чи кейси, які підтверджують, що вам можна вірити. |
| offer ladder, tiers | драбина оферів | кілька оферів від безкоштовного до найдорожчого, які ведуть того самого клієнта до одного результату; на кожній сходинці він платить і довіряє більше |
| Follow-primary, Creator Mode | кнопка «Стежити» головною в профілі | Налаштування, за якого незнайомі люди підписуються на автора замість запиту в контакти; окремий Creator Mode LinkedIn уже прибрав. |
| факти-патрони | перевірені цифри автора | Біографічні й робочі цифри з джерелом, які можна ставити в пост і на креатив; інших цифр не вигадуємо. |
| hook / free offer, lead magnet | безкоштовний вхід | аудит, розрахунок втрат або розбір, що показує проблему і веде до розмови |
| voice profile, voice | манера письма автора | Як автор пише: слова, ритм, улюблені звороти і список того, чого він ніколи не пише. |
<!-- glossary:end -->

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
