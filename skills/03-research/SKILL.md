---
name: 03-research
description: Step 3 of the Content Engine flow. Weekly research layer that refills the Idea Pool from six sources — call transcripts (Fathom), the author own work-stream, LinkedIn topic-cluster outliers (Apify), comment mining, TikTok viral trends, and Reddit pain-mining. Applies the 3-criteria gate, dedupes against the pool, tags pillar/funnel/hook/competence, scores, and writes Status=new ideas to Notion. Use when the user says запусти ресерч, research layer, наповни idea pool, знайди ідеї для контенту, or it is the weekly research run.
argument-hint: "[client] [--source=fathom|work|outliers|comments|tiktok|reddit|all] [--since=7d]"
---

# 03 · Research — наповнення Idea Pool

Третій крок Content Engine. **Не вигадує теми з повітря** — тягне сире з 4 джерел за період,
проганяє через гейт, дедуплікує і пише ідеї в Idea Pool. Далі 04-weekly-plan вибирає з пулу.

**Вхід:** `$ARGUMENTS` — клієнт (дефолт — єдиний активний), опц. `--source` (дефолт `all`),
опц. `--since` (дефолт `7d`). Структурований вхід/вихід — щоб n8n міг викликати крок через SDK.

## 0 · Конфіг (з Notion, не з репо)

Прочитай research-config клієнта (під-сторінка «🔎 {Client} · Research Sources» на хабі
«Content Engine»; якщо нема — створи з дефолтами і познач [ПРИПУЩЕННЯ], попроси відредагувати):
- **Watchlist креаторів** (джерело C): 15–25 профілів у topic-кластері клієнта (peers + thought
  leaders з Секції 2 стратегії). НЕ generic-вірал — лише ніша.
- **Fathom scope** (джерело A): які типи дзвінків мінити (дефолт: client / discovery / sales /
  mentoring) + **правило анонімізації** (узагальнювати, без імен клієнтів — як «без NDA» у стратегії).
- **TikTok seeds** (джерело E): хештеги/креатори в бізнес-сейлз-founder ніші (з Make-сценарію Viktor).
- **Reddit субредити** (джерело F): список сабредитів ICP-світу (з Make-сценарію Viktor).
- **Source toggles**: які з 6 джерел активні цього клієнта.

## Джерела (за пріоритетом — для Viktor дзвінки > скрейп)

### A · Дзвінки (Fathom) — найвищий сигнал
Fathom MCP: `list_meetings` (за `--since`) → відфільтруй по scope → `get_meeting_transcript` /
`get_meeting_summary`. Витягни:
- **повторювані питання** фаундерів → теми П1 (методологія) і lead-magnet ідеї;
- **заперечення / хибні переконання** → теми П2 (contrarian);
- **verbatim-мову ICP** (болі, цілі, страхи) → сировина для хуків і JTBD-перевірки;
- **діалоги** («Я: … / Він: …») → готовий story-wrapped вхід (топ-патерн Viktor).
Кожен інсайт → `Source = call-insight`, у Notes — узагальнений контекст (анонімно), у Source link —
Fathom URL (внутрішній, не для поста).

### B · Власний робочий потік — build-in-public + hands-on
Аналог «internal Slack» для solo. Джерела: daily-логи, свіжа Notion-робота, Claude-сесії
(як побудова цього engine), фінмоделі, GTM-деліверабли (анонімно). Витягни «ось що я зараз
будую/роблю» → теми П3 (AI/Claude) і П4 (personal). `Source = own-thought`.

### C · LinkedIn-аутлаєри в кластері — реюз `/viral-research`
Виклич скіл **`viral-research`** по watchlist (Apify) → 5x+ аутлаєри vs медіана креатора.
⚠️ Interest Graph: беремо аутлаєри **в topic-кластері клієнта**, не generic. Аутлаєр →
ідея в пул ТІЛЬКИ якщо у клієнта є competence proof на цю тему (інакше — це формат-референс,
не ідея: клади у Notes картки спорідненої ідеї як «кут подачі», а не окремим записом).
`Source = research-outlier`, Source link — URL оригіналу.

### D · Коментарі
Свої пости (Posts DB, коли запрацює 07) + коменти під постами watchlist (Apify). Витягни
питання/болі, що повторюються в коментах → теми П1/П2. `Source = comment-mining`.

### E · TikTok-тренди (Apify) — формат/хук-патерни, «steal like an artist»
Існує як Make-сценарій Viktor (TikTok→Telegram). Тут — нативно: Apify TikTok scraper по seed-ах
з конфіга (хештеги/креатори в бізнес-сейлз-founder ніші) → вірусні short-form. Беремо **патерн
хука й формат**, не тему (TikTok-вірал ≠ GTM-для-агенцій). Обов'язковий крок — **реframe під ICP**:
короткий хук-патерн → переклад на біздев-проблему агенцій. `Source = tiktok-trend`, Source link — URL.
Ближче до C (референс), ніж до болю — частіше йде в Notes картки як «кут подачі».

### F · Reddit-болі (Apify) — реальні питання ICP-світу
Існує як Make-сценарій Viktor (Reddit→Telegram). Нативно: Apify Reddit scraper по сабредитах
з конфіга (r/agency, r/sales, r/msp, r/Entrepreneur, r/startups…) → треди, де фаундери/сейли
скаржаться на пайплайн, найм, позиціонування. Це **публічний аналог дзвінків (A)**: verbatim-болі
й питання в словах ICP-світу → теми П1/П2. Обов'язково — **реframe під твій ICP** (generic Reddit-
біль ≠ пост без твого proof/кута). `Source = reddit-pain`, Source link — URL треду.

> 📌 Make-сценарії TikTok/Reddit (Haiku→Telegram «LinkedIn Drafts») Viktor уже має. Цей скіл —
> їхній «мозок»: ті самі джерела, але через гейт/дедуп/тег/competence + голос Viktor, у Idea Pool
> (не сирі чернетки в Telegram). Make лишається як опційний тригер (нервова система) — згодом n8n.

## Конвеєр обробки (для кожного кандидата)

1. **Гейт 3 критеріїв** (`methodology.md` §2.1): хук>ідея · є competence proof (або запасна
   стратегія §2.3: research-backed / «ось що я роблю» / своя історія) · унікальний фід.
   Провалив усі — відкидаємо, не пишемо.
2. **Дедуп** проти Idea Pool: семантично порівняй з наявними (Name + Hook draft + Notes).
   Близький дубль — пропусти АБО збагати наявну картку новим кутом (не плоди записи).
3. **Пауза реюзу**: якщо тема перетинається з карткою, де `Last used` < 1–3 міс — пропусти.
4. **Тег**: `Pillar` (1 з 4) · `Funnel` · `Format` (пропозиція, не фікс) · чернетка `Hook draft`
   за `hook-bank.md` · `Competence proof` · `Source` · `Source link`.
5. **Скор** 0–100 (як hook-bank §скоринг): viral lever × специфічність × відповідність voice ×
   свіжість сигналу. Сигнал з дзвінка/реального болю > matrix-expansion.
6. **Запис**: `Status = new` у Idea Pool (`notion-schema.md`).

## Вихід

1. Нові картки в 💡 Idea Pool (data_source — з `notion-schema.md` / пам'яті проєкту).
2. Короткий **дайджест** користувачу: скільки додано на джерело, топ-5 за скором, що відкинуто
   і чому. (Цей дайджест — кандидат на Telegram-доставку, коли крок обгорнемо в n8n.)
3. Повернути структурований summary оркестратору (для ланцюга 03→04).

## Definition of Done

- Прочитано research-config (або створено дефолтний + прапор на редагування).
- Пройдено активні джерела за `--since`; кожне дало інсайти або явно «нічого нового».
- Кожна нова картка проходить гейт competence proof; дублі не створені; паузи реюзу враховані.
- Idea Pool поповнено; дайджест показано; summary повернуто.
- ⚠️ Жодних реальних імен клієнтів у картках (анонімізація дзвінків/деліверабл).
