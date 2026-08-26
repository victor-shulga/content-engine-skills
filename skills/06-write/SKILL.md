---
name: 06-write
description: Step 6 of the Content Engine flow. Writes the publish-ready LinkedIn post text UNDER the creative from 05, in the author's voice — runs the writing process, picks the hook, applies the copy framework, humanizes (removes AI traces), formats, attaches the distribution playbook, then runs a blind grade gate (fresh subagent scores the draft against grader-rubric.md, loops until ≥90 & 0 hard-fails). Use when the user says напиши пост, текст під креатив, допиши пост, фіналізуй пост, write the post, or it is the writing step for an idea that already has a creative.
argument-hint: "<idea-name-or-id> [client]"
---

# 06 · Write — пост під креатив

Шостий крок (після свапу — текст ПІСЛЯ креативу). Бере картку Idea Pool + готовий креатив (05) і
пише **publish-ready** текст у голосі автора. **Не пише з нуля сам — роутер над процесом
`linkedin-post-writing`** (кроки Viktor: ідея → проблема+м'ясо → копірайтинг-фреймворк →
резюме → трейлер → humanize → формат), з прив'язкою до ідеї/креативу, і закриває **grade gate**
(сліпий суддя по рубриці, крок 8) перед показом.

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
6. **Формат:** «ялинки», короткі рядки, ритм; target 120-250 слів (900-1700 знаків), стеля 300 (§3.5).
7. **CTA:** директив — команда, коментар-гейт або «напишіть в особисті». НІКОЛИ не питання.
8. **Grade gate (сліпий суддя):** зібраний драфт прогнати через `${CLAUDE_PLUGIN_ROOT}/reference/grader-rubric.md`.
   - **Спершу структурний передгейт** (розділ у рубриці): myth flip, тріада, дзеркальна пара, reversal, upsell через кому, порожній розгін, тире, рівний ритм. Спрацювало → фіксимо і перевіряємо ще раз, суддю спавнимо лише на чистому драфті. Автоматизується детектором зі скіла `anticopywriting-ai`.
   - **Окремий субагент** (Task, чистий контекст) — НЕ грейдити в цьому ж виклику, інакше самооман. Дає ТІЛЬКИ: текст + тип/формат + «ЩО НІКОЛИ НЕ ПИШЕМО» + рубрику. Не дає бекстори (чому ідея, референс, hook draft).
   - Суддя вертає JSON: `scores` по 7 категоріях · `total` · `hard_fails` · `lowest` · `one_fix`.
   - **Гейт = передгейт чистий І total ≥ 90 І hard_fails порожні.** Не взято → фіксимо hard_fails першими, тоді `lowest` (застосувати `one_fix`) → **rescore свіжим субагентом** (не «докрути»). Повтор.
   - **Стоп після 3 ітерацій** без гейта → показати драфт із поміткою «gate не взято, найслабше = X», рішення за людиною. Тихий авто-шип нижче 90 — заборонено.
   - Пропускати гейт не можна: пост показуємо користувачу вже після взяття (або з явним прапором).

## Distribution playbook (додати до поста)
З `methodology.md` §4: T-20хв коменти кластеру · час · перша година nurture · лінк у body (конверсія)
або без лінків (охоплення) — НЕ в першому коменті · self-repost 4-6год ×1 · 0 хештегів · saves-CTA.

## Вихід
1. **Publish-ready пост** (текст + лінк на креатив) — показати користувачу вже ПІСЛЯ взяття гейта; у summary фінальний `total` score.
2. **Posts DB:** створити чернетку (Name=хук, pillar/funnel/format копія, Idea relation, статус чернетки, `grader_score` = фінальний total, `grader_iterations` = скільки раундів).
3. **Idea Pool:** картка → `Status = written`, `Last used` = дата.
4. **Telegram** канал «LinkedIn Drafts» (коли підключимо токен/n8n): пост + креатив + playbook.
5. Summary: готовий пост, що далі (публікація вручну → потім метрики у трекінг-тул).

## Definition of Done
- Текст у голосі автора; пройдено anticopywriting; «ЩО НІКОЛИ НЕ ПИШЕМО» дотримано.
- Хук за hook-bank (≤10 слів, число якщо доречно); 2-3 варіанти, кращий обрано.
- Структура за типом (карусель = caption; кейс = 8 елементів); цифри лише з фактів-патронів.
- Без comment-to-get; distribution playbook прикріплено.
- **Grade gate взято** (сліпий субагент, total ≥ 90, 0 hard_fails) АБО явний прапор «gate не взято» після 3 ітерацій.
- Posts DB чернетка створена (з `grader_score`); Idea Pool → written; summary повернуто (з фінальним score).
