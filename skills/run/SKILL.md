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
| 02 | `02-profile-audit` — аудит профілю, банер, featured | раз + після ребрендів | 🔜 планується |
| 03 | `03-research` — research layer: outliers, дзвінки, коменти → Idea Pool | щотижня (cron) | 🔜 планується |
| 04 | `04-weekly-plan` — тижневий план: 2–3 варіанти на слот → затвердження | щотижня | 🔜 планується |
| 05 | `05-write` — хуки → скоринг → драфт у голосі → грейдер-цикл | на кожен пост | 🔜 планується |
| 06 | `06-creative` — креативи: карусель/інфографіка/single image | на кожен пост | 🔜 планується |
| 07 | `07-track` — інжест метрик → Posts DB → аналітика-дашборд | щотижня + місячний цикл | 🔜 планується |
| 08 | `08-repurpose` — топ-30/50 постів за рік → план перевикористання по форматах | бекфіл раз + щомісяця | 🔜 планується |
| 09 | `09-engage` — комент-радар: свіжі пости ICP/peers зі списків → драфти коментарів | 1–2 рази на день (cron) | 🔜 планується |

## Маршрутизація

1. Розпарсь `$ARGUMENTS`: клієнт (дефолт — запитай або візьми єдиного активного) і крок.
2. Кроку нема в аргументах → подивись стан клієнта в Notion і запропонуй наступний логічний:
   - нема сторінки «🧭 {Client} · Strategy» → почни з `content-engine:01-strategy`;
   - стратегія є, тиждень не спланований → 04 (поки не збудований — повідом і запропонуй
     зробити план вручну за methodology §2.5);
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
