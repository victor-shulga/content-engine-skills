---
name: content-run
description: Orchestrator of the Content Engine flow. Routes to the right step — strategy, profile audit, research, weekly plan, production, creatives, tracking — keeps per-client state in Notion, and explains the flow. Use when the user says запусти content engine, контент движок, next content step, or asks what the content engine flow is.
argument-hint: "[client] [step]"
---

# Content Engine · Оркестратор

Флоу engine (стан клієнта живе в Notion — сторінка «Content Engine»):

| Крок | Скіл | Каденс | Статус |
|---|---|---|---|
| 01 | `content-engine:content-linkedin-strategy` — стратегія-конфіг у Notion | раз + ревізія щокварталу | ✅ |
| 02 | `content-engine:content-profile-audit` — аудит профілю + банер-бриф + Featured-план | раз + після ребрендів | ✅ |
| 03 | `content-engine:content-research` — research layer: Fathom-дзвінки, власний потік, LinkedIn, коменти, TikTok, Reddit → Idea Pool | щотижня (cron) | ✅ |
| 04 | `content-engine:content-weekly-plan` — тижневий рекомендатор: 2–3 варіанти на слот зі скором → затвердження | щотижня | ✅ |
| 05 | `content-engine:content-creative` — креативи: карусель/інфографіка/single image (роутер над дизайн-скілами) | на кожен пост | ✅ |
| 06 | `content-engine:content-write` — пост під креатив: голос → хук → фреймворк → humanize → publish-ready | на кожен пост | ✅ |
| 07 | `content-engine:content-repurpose` — переможці (топ за рік / Posts DB) → переробка в нові формати → Idea Pool | бекфіл раз + щомісяця | ✅ |
| 08 | `content-engine:content-engage` — комент-радар: `targets` (4 аудиторії → boolean → список профілів) · `radar` (свіжі пости → драфти коментарів) · `log` (факт + майнінг у research) | targets раз + добір; radar 1–2×/день | ✅ |
| 09 | `content-engine:content-track` — трекінг: інжест експортів → архів + Posts DB, скоринг (резонанс × діалоги), місячне калібрування ваг у стратегію | інжест+скор щотижня; калібрування щомісяця | ✅ |

> **Креатив → пост** (свап 05/06): за Module 4 «креатив головніший за текст» — спершу візуал
> (стопить скрол), потім текст під нього. Хук-чернетка для креативу вже є в картці Idea Pool.
> **Трекінг замикає цикл:** `content-track` пише метрики в Posts DB, ставить тіри й раз на місяць
> кладе відкалібровані ваги в Секцію 7 стратегії — звідки їх бере `content-weekly-plan`. Без нього
> рекомендатор скорить на дефолтних гіпотезах, а `content-repurpose --from-tracking` не має входу.

## Маршрутизація

1. Розпарсь `$ARGUMENTS`: клієнт (дефолт — запитай або візьми єдиного активного) і крок.
2. Кроку нема в аргументах → подивись стан клієнта в Notion і запропонуй наступний логічний:
   - нема сторінки «🧭 {Client} · Strategy» → почни з `content-engine:content-linkedin-strategy`;
   - стратегія є, профіль не аудитований → `content-engine:content-profile-audit`;
   - стратегія є, Idea Pool порожній/застарілий → `content-engine:content-research` (наповнити пул);
   - пул повний, тиждень не спланований → `content-engine:content-weekly-plan`;
   - план затверджений → 05/06 по слотах;
   - пости опубліковані, метрики не інжестнуті → `content-engine:content-track`.
3. Не вигадуй кроки, яких ще нема, — статус у таблиці вище. Якщо користувач просить
   незбудований крок, скажи прямо і запропонуй ручний еквівалент за
   `${CLAUDE_PLUGIN_ROOT}/reference/methodology.md`.

## Інваріанти (для всіх кроків)

- Мова виходів — українська; дані клієнта verbatim — мовою оригіналу.
- Усі правила контенту — з `reference/methodology.md`; хуки — з `reference/hook-bank.md`;
  Notion-структури — з `reference/notion-schema.md`; стратегія — `reference/strategy-template.md`;
  вимірювання — `reference/tracking-rules.md`.
- Дизайн-роботи для Viktor — бренд-кіт Victor Shulga (білий фон, корал #E85A4F);
  для клієнтів — їхні бренд-кіти. Ніколи не змішувати.
- Кожен крок завершується коротким summary + що далі.

## Terms and plain-language output

<!-- glossary:start terms=idea-pool,content-pillar,repurpose -->
Rules for every document a client or their team will read (review, roast, canvas, offer cards, instruction):

1. **Open with «Словник цього документа»**: only the terms that actually appear in it, at most 10, each as «термін: що це простими словами». Like the definitions section of a contract.
2. **No internal codes or letter scales in the text** (A/B/C, D L T E, BLEND numbers without words, Own/Shared/Generic, Z1.4, GATE 2.5, T1–T6). Write the meaning instead: «є цифра з клієнтом», not «A».
3. **Use the plain form from the table below.** English stays only for tool names and for copy that ships in English (promises, hooks, subject lines). If the document is in another language, translate the plain form, never the internal term.
4. **Do not score what cannot exist yet.** A block that depends on work not done (signal catalog, case studies, a previous step) gets «пропущено: спершу потрібно <що саме>», not a score.
5. **Every section of a review opens with one concrete action** («до наступного дзвінка: …»), then at most five lines of why. No paragraph that only restates the framework.


| Internal term (this skill) | Write for the reader | What it means |
|---|---|---|
| Idea Pool | банк ідей | Таблиця в Notion з усіма ідеями для постів, з якої щотижня вибирають теми. |
| pillar, П1–П4 | тема-опора | Одна з 3–5 постійних тем автора; у документі пишемо назву теми словами, без кодів П1–П4. |
| repurpose, recycle | переробка поста | Пост, що вже спрацював, переписуємо в іншому форматі чи з іншого боку, бо інтерес до теми вже доведено. |
<!-- glossary:end -->
