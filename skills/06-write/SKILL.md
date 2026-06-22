---
name: 06-write
description: Step 6 of the Content Engine flow. Writes the publish-ready LinkedIn post text UNDER the creative from 05, in the author's voice — runs the 7-step writing process, picks the hook, applies the copy framework, humanizes (removes AI traces), formats, and attaches the distribution playbook. Use when the user says напиши пост, текст під креатив, допиши пост, фіналізуй пост, write the post, or it is the writing step for an idea that already has a creative.
argument-hint: "<idea-name-or-id> [client]"
---

# 06 · Write — пост під креатив

Шостий крок (після свапу — текст ПІСЛЯ креативу). Бере картку Idea Pool + готовий креатив (05) і
пише **publish-ready** текст у голосі автора. **Не пише з нуля сам — роутер над процесом
`linkedin-post-writing`** (7 кроків Viktor: ідея → проблема+м'ясо → копірайтинг-фреймворк →
резюме → трейлер → humanize → формат), з прив'язкою до ідеї/креативу.

**Вхід:** `$ARGUMENTS` — ідея (з креативом від 05) + клієнт. Якщо креативу ще нема і формат ≠
text-only — спершу `content-engine:05-creative`.

## Що читаємо
1. **Картка Idea Pool:** hook draft · pillar · funnel · format · competence proof · notes · source.
2. **Креатив (05):** для каруселі — контент слайдів (текст = лише однорядковий caption); для
   single image / infographic — повний пост під візуал.
3. **Стратегія (Notion) Секція 6 Voice** + скіл `about-viktor`: тон, signature, фірмові патерни,
   **«ЩО НІКОЛИ НЕ ПИШЕМО»**.
4. **Правила:** `${CLAUDE_PLUGIN_ROOT}/reference/hook-bank.md` (хуки) +
   `${CLAUDE_PLUGIN_ROOT}/reference/methodology.md` §3 (фреймворки/структура/форматування), §4 (distribution).

## Процес (реюз `linkedin-post-writing`)
1. **Фреймворк за типом:** PAS (contrarian/проблема) · BAB (кейс/how-i) · AIDA (giveaway/hand raiser).
2. **Хук:** візьми hook draft з картки → згенеруй 2-3 варіанти за hook-bank (7-10 слів, число у 8/10,
   без emoji в 1-му рядку, 2 ключових слова) → обери найкращий, решту збережи в Notes для реюзу.
3. **Структура** (усі формати КРІМ каруселі): трейлер(хук+рехук) → проблема(+підсилення) → м'ясо →
   резюме(+CTA). Кейс-стаді (BOFU) — 8 елементів (§3.7). **Карусель — лише однорядковий caption.**
4. **Цифри — тільки з фактів-патронів** (стратегія Секція 9), не вигадані.
5. **Humanize:** прогнати через `anticopywriting-ai` — прибрати AI-сліди (довгі тире,
   «не X, а Y»-шаблон, канцелярит); звірити з «ЩО НІКОЛИ НЕ ПИШЕМО».
6. **Формат:** «ялинки», короткі рядки, ритм; target 400-500 слів (text-heavy) / 1400-1800 знаків.
7. **CTA:** питання / «зберігайте» / hand raiser — БЕЗ comment-to-get (bait-ризик 2026).

## Distribution playbook (додати до поста)
З `methodology.md` §4: T-20хв коменти кластеру · час · перша година nurture · лінк у body (конверсія)
або без лінків (охоплення) — НЕ в першому коменті · self-repost 4-6год ×1 · 0 хештегів · saves-CTA.

## Вихід
1. **Publish-ready пост** (текст + лінк на креатив) — показати користувачу.
2. **Posts DB:** створити чернетку (Name=хук, pillar/funnel/format копія, Idea relation, статус чернетки).
3. **Idea Pool:** картка → `Status = written`, `Last used` = дата.
4. **Telegram** канал «LinkedIn Drafts» (коли підключимо токен/n8n): пост + креатив + playbook.
5. Summary: готовий пост, що далі (публікація вручну → потім метрики у трекінг-тул).

## Definition of Done
- Текст у голосі автора; пройдено anticopywriting; «ЩО НІКОЛИ НЕ ПИШЕМО» дотримано.
- Хук за hook-bank (≤10 слів, число якщо доречно); 2-3 варіанти, кращий обрано.
- Структура за типом (карусель = caption; кейс = 8 елементів); цифри лише з фактів-патронів.
- Без comment-to-get; distribution playbook прикріплено.
- Posts DB чернетка створена; Idea Pool → written; summary повернуто.
