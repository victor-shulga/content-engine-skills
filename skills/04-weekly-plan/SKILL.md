---
name: 04-weekly-plan
description: Step 4 of the Content Engine flow. The weekly recommender — the heart of the system. Reads the client strategy (pillars, rhythm) and the Idea Pool, resolves this week's slots, and recommends 2-3 scored idea options per slot with a rationale, so the user approves a week in ~5 minutes instead of suffering a rigid calendar. Writes a Weekly Plan to Notion + a Telegram digest. Use when the user says тижневий план, weekly plan, що постити цього тижня, склади план на тиждень, or it is the weekly planning run.
argument-hint: "[client] [week-start YYYY-MM-DD]"
---

# 04 · Weekly Plan — рекомендатор тижня

Серце Content Engine. **НЕ жорсткий календар** — для кожного слоту тижня дістає з Idea Pool
2-3 найкращі варіанти зі скором і поясненням «чому саме це зараз». Користувач затверджує за 5 хв.
Це рішення болю: «сиджу і вибираю з жорсткого плану з поганими темами».

**Вхід:** `$ARGUMENTS` — клієнт (дефолт — єдиний активний) + week-start (дефолт — найближчий
понеділок). Структурований вхід/вихід (n8n-callable через SDK).

## Читаємо

1. **Стратегія (Notion `🧭 {Client} · Strategy`):** Секція 4 — пілари (funnel, день), ритм
   (N постів/тиждень, дні); Секція 7 — viral levers (ваги, відкалібровані трекінг-тулом); Секція 6 — voice.
2. **Idea Pool (`${CLAUDE_PLUGIN_ROOT}/reference/notion-schema.md`):** усі картки
   `Status` ∈ {new, recommended}, з pillar/funnel/format/hook/competence/score/source/Last used.
3. **Posts DB (якщо трекінг-тул вже працює):** performance-пріори по піларах/темах/форматах — вага в скор.
4. **Правила:** `${CLAUDE_PLUGIN_ROOT}/reference/methodology.md` §2.5 (ритм), §2.6 (рециркуляція),
   §4 (distribution каденси).

## Крок 1 · Резолв слотів тижня

Зі стратегії-ритму збудуй сітку слотів (день → funnel → пілар → формат). Застосуй календарні
правила (приклад для персонального бренду, бери з конкретної стратегії клієнта):
- **Вт** MOFU · П1 (експертиза)
- **Ср** MOFU↔BOFU · П1 — **парний тиждень = BOFU** (giveaway / case / hand raiser), непарний = MOFU milestone-lesson
- **Чт** MOFU · **П2↔П3 чергування по тижнях**
- **Пт** TOFU · П4 — **перша Пт місяця = fitness P&L** (build-in-public), інші = solopreneur/milestone
- Каденс-обмеження: карусель ≤ 1×/2 тижні; comment-to-get НЕ використовуємо (bait-ризик 2026 — див. distribution §6); fitness рівно 1×/міс.

## Крок 2 · Кандидати на слот

Для кожного слоту фільтруй Idea Pool: `Pillar` = пілар слоту · `Funnel` сумісний · `Status` ∈
{new, recommended} · **пауза реюзу**: `Last used` порожній або > 1-3 міс · формат сумісний зі слотом
(або гнучкий). Якщо для слоту < 2 кандидатів — прапор «пул бідний на {пілар}», запропонуй
`content-engine:03-research --source=...` або matrix-expansion fill.

## Крок 3 · Скор і ранжування → топ 2-3

Ранг кандидата = **базовий Score (Idea Pool)** × коефіцієнти:
- **viral lever** (вага з Секції 7, відкалібрована на власних даних — у Viktor vulnerability/personal б'є теорію);
- **performance prior** (Posts DB: цей пілар/тема/формат історично заходив? +/−);
- **freshness** (call-insight / reddit-pain / свіжий сигнал > matrix-expansion);
- **balance-penalty**: мінус, якщо тема/кут уже обрані в цьому тижні або були минулого (різноманіття);
- **competence gate** (нема proof і нема запасної стратегії → відсікти).
Бери топ 2-3 на слот. Якщо один сильно домінує — постав його перший, але дай ≥1 альтернативу.

## Крок 4 · Раціонале

Для кожного варіанта — 1 рядок «чому це зараз»: який lever тягне, чому свіже/на часі, який proof
підкріплює. Це щоб користувач ДОВІРЯВ рекомендації, а не вибирав наосліп.

## Крок 5 · Вихід (Notion + Telegram)

1. Сторінка в **📅 Weekly Plans** (`{Client} · Тиждень N (дата-дата)`, Status=`draft`→`sent`):
   таблиця слотів — день · funnel · формат · **2-3 варіанти** (relation на Idea Pool) ·
   рядок раціонале на кожен · колонка **Вибір** (чекбокс/позначка користувача).
2. **Telegram-дайджест** у налаштований канал: короткий список слотів з топ-варіантом + лінк на
   Notion-сторінку плану (chat_id — з конфіга; reuse каналу контент-доставки).

## Крок 6 · Затвердження (loop)

Користувач позначає вибір (у Notion-колонці «Вибір» або відповіддю). На наступному виклику /
по команді: вибрані ідеї → `Status = approved` в Idea Pool (решта лишаються `recommended`);
план → `Status = approved`. Далі 05-creative → 06-write беруть `approved` по слотах.

## Definition of Done

- Слоти тижня зрезолвлені за ритмом + календарними правилами (fitness/BOFU/чергування/карусель).
- Кожен слот має 1-3 варіанти зі скором і рядком раціонале; бідні слоти позначені.
- Паузи реюзу й балансування дотримані (без повтору теми/кута).
- Сторінка плану в Weekly Plans створена (Status sent); Telegram-дайджест надіслано.
- Механіка затвердження пояснена; після вибору — промоушн у Idea Pool відпрацьовує.
