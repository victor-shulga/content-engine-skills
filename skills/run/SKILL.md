---
name: run
description: Orchestrator of the Content Engine flow. Routes to the right step — strategy, profile audit, research, weekly plan, production, creatives, tracking — keeps per-client state in Notion, and explains the flow. Use when the user says запусти content engine, контент движок, next content step, or asks what the content engine flow is.
argument-hint: "[client] [step]"
---

# Content Engine · Оркестратор

Флоу engine (стан клієнта живе в Notion — сторінка «Content Engine»):

| Крок | Скіл | Каденс | Статус |
|---|---|---|---|
| 01 | `content-engine:01-strategy` — стратегія-конфіг у Notion | раз + ревізія щокварталу | ✅ |
| 02 | `content-engine:02-profile-audit` — аудит профілю + банер-бриф + Featured-план | раз + після ребрендів | ✅ |
| 03 | `content-engine:03-research` — research layer: дзвінки (Fathom), власний потік, outliers, коменти, TikTok, Reddit → Idea Pool | щотижня (cron) | ✅ |
| 04 | `content-engine:04-weekly-plan` — тижневий рекомендатор: 2–3 варіанти на слот зі скором → затвердження | щотижня | ✅ |
| 05 | `content-engine:05-creative` — креативи: карусель/інфографіка/single image (роутер над дизайн-скілами) | на кожен пост | ✅ |
| 06 | `content-engine:06-write` — пост під креатив: голос → хук → фреймворк → humanize → publish-ready | на кожен пост | ✅ |
| 07 | `07-repurpose` — топ-30/50 постів за рік → план перевикористання по форматах | бекфіл раз + щомісяця | 🔜 планується |
| 08 | `08-engage` — комент-радар: свіжі пости ICP/peers зі списків → драфти коментарів | 1–2 рази на день (cron) | 🔜 планується |

> **Креатив → пост** (свап 05/06): за Module 4 «креатив головніший за текст» — спершу візуал
> (стопить скрол), потім текст під нього. Хук-чернетка для креативу вже є в картці Idea Pool.
> **Трекінг (метрики → Posts DB → дашборд + рециркуляція)** ВИНЕСЕНО з цього скілсета в окремий
> тул (план: standalone `linkedin-tracking`). Posts DB лишається; калібрування виглядів/скорів
> приходить ВІД того тулу.

## Маршрутизація

1. Розпарсь `$ARGUMENTS`: клієнт (дефолт — запитай або візьми єдиного активного) і крок.
2. Кроку нема в аргументах → подивись стан клієнта в Notion і запропонуй наступний логічний:
   - нема сторінки «🧭 {Client} · Strategy» → почни з `content-engine:01-strategy`;
   - стратегія є, профіль не аудитований → `content-engine:02-profile-audit`;
   - стратегія є, Idea Pool порожній/застарілий → `content-engine:03-research` (наповнити пул);
   - пул повний, тиждень не спланований → `content-engine:04-weekly-plan`;
   - план затверджений → 05/06 по слотах.
3. Не вигадуй кроки, яких ще нема, — статус у таблиці вище. Якщо користувач просить
   незбудований крок, скажи прямо і запропонуй ручний еквівалент за
   `${CLAUDE_PLUGIN_ROOT}/reference/methodology.md`.

## Інваріанти (для всіх кроків)

- Мова виходів — українська; дані клієнта verbatim — мовою оригіналу.
- Усі правила контенту — з `reference/methodology.md`; хуки — з `reference/hook-bank.md`;
  Notion-структури — з `reference/notion-schema.md`; стратегія — `reference/strategy-template.md`.
- Дизайн-роботи для Viktor — бренд-кіт Victor Shulga (білий фон, корал #E85A4F);
  для клієнтів — їхні бренд-кіти. Ніколи не змішувати.
- Кожен крок завершується коротким summary + що далі.
