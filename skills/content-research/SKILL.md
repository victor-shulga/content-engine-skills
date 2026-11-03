---
name: content-research
description: Step 3 of the Content Engine flow. Weekly research layer that refills the Idea Pool from six sources — call transcripts (Fathom), the author own work-stream, LinkedIn topic-cluster outliers (Apify), comment mining, TikTok viral trends, and Reddit pain-mining. Applies the 3-criteria gate, dedupes against the pool, tags pillar/funnel/hook/competence, scores, and writes Status=new ideas to Notion. Use when the user says запусти ресерч, research layer, наповни idea pool, знайди ідеї для контенту, or it is the weekly research run.
argument-hint: "[client] [--source=fathom|work|outliers|comments|tiktok|reddit|all] [--since=7d]"
---

# 03 · Research — наповнення Idea Pool

Третій крок Content Engine. **Не вигадує теми з повітря** — тягне сире з 4 джерел за період,
проганяє через гейт, дедуплікує і пише ідеї в Idea Pool. Далі content-weekly-plan вибирає з пулу.

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
⚠️ Тег П4 Personal ставиться лише темам, що проходять Personal-тест (див. `content-weekly-plan` Крок 1): робочий
кейс у першій особі (ціна, воркшоп, метрика, інструмент) — це П1/П3, не Personal.

### C · LinkedIn-аутлаєри в кластері (Apify, no-cookie — нуль ризику для акаунта)
Два режими, ОБИДВА без cookie/логіну (акаунт автора не ризикує; li_at НЕ потрібен — його
лишаємо для трекінг-тулу / content-engage):
- **C1 · По креаторах (watchlist):** `apimaestro/linkedin-profile-posts` по кожному профілю
  watchlist → 5x+ аутлаєри vs медіана креатора. (той самий актор, що тягнув 50 постів
  van der Blom — 100% success). Якщо встановлено окремий скіл для пошуку вірусних постів, можна через нього.
- **C2 · По темі (keyword/hashtag search):** `apimaestro/linkedin-posts-search-scraper-no-cookies`
  (keyword) або `harvestapi/linkedin-post-search` (дешевше ~$0.002/пост, багатші фільтри:
  author industry / keywords / mentions) → вірусні пости НА ТЕМУ по всьому LinkedIn, навіть від
  людей поза watchlist. ОБОВ'ЯЗКОВО фільтрувати до кластера (author job title / industry /
  keywords), інакше — generic-вірал.
⚠️ Interest Graph: аутлаєри **в topic-кластері клієнта**, не generic. Аутлаєр → ідея в пул
ТІЛЬКИ якщо у клієнта є competence proof на тему (інакше — формат/кут-референс у Notes сусідньої
картки, не окремий запис). `Source = research-outlier`, Source link — URL оригіналу.

### D · Коментарі
Свої пости (Posts DB, коли запрацює трекінг-тул) + коменти під постами watchlist (Apify). Витягни
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
   за `hook-bank.md` · `Competence proof` · `Problem` (хто її має · що втрачає · широка чи вузька; ширша
   формула тієї ж ідеї краща за вузьку) · `Source` · `Source link`.
5. **Скор** 0–100 (як hook-bank §скоринг): viral lever × специфічність × відповідність voice ×
   свіжість сигналу. Сигнал з дзвінка/реального болю > matrix-expansion.
6. **Запис**: `Status = new` у Idea Pool (`notion-schema.md`).

## Terms and plain-language output

<!-- glossary:start terms=idea-pool,outlier-post,competence-proof,content-pillar,tofu-mofu-bofu,hook,idea-source,matrix-expansion,topic-authority,jtbd,viral-lever -->
Rules for every document a client or their team will read (review, roast, canvas, offer cards, instruction):

1. **Open with «Словник цього документа»**: only the terms that actually appear in it, at most 10, each as «термін: що це простими словами». Like the definitions section of a contract.
2. **No internal codes or letter scales in the text** (A/B/C, D L T E, BLEND numbers without words, Own/Shared/Generic, Z1.4, GATE 2.5, T1–T6). Write the meaning instead: «є цифра з клієнтом», not «A».
3. **Use the plain form from the table below.** English stays only for tool names and for copy that ships in English (promises, hooks, subject lines). If the document is in another language, translate the plain form, never the internal term.
4. **Do not score what cannot exist yet.** A block that depends on work not done (signal catalog, case studies, a previous step) gets «пропущено: спершу потрібно <що саме>», not a score.
5. **Every section of a review opens with one concrete action** («до наступного дзвінка: …»), then at most five lines of why. No paragraph that only restates the framework.


| Internal term (this skill) | Write for the reader | What it means |
|---|---|---|
| Idea Pool | банк ідей | Таблиця в Notion з усіма ідеями для постів, з якої щотижня вибирають теми. |
| outlier, 5x+ outlier | пост, що вистрілив | Пост, який зібрав у 5 і більше разів більше реакцій, ніж зазвичай у цього автора; беремо його як зразок подачі. |
| competence proof | доказ, що автор у темі | Реальний досвід, цифра чи кейс автора; без нього пост на цю тему не пишемо. |
| pillar, П1–П4 | тема-опора | Одна з 3–5 постійних тем автора; у документі пишемо назву теми словами, без кодів П1–П4. |
| TOFU / MOFU / BOFU, funnel | етап воронки: знайомство · інтерес · рішення | Показує, для кого пост: для тих, хто вас ще не знає, хто вже придивляється, або хто готовий купувати. |
| hook, cold hook | гачок | перший рядок листа, через який людина читає далі |
| Source = call-insight / own-thought / research-outlier / comment-mining / tiktok-trend / reddit-pain | звідки ідея: дзвінок · власна робота · чужий пост, що вистрілив · коментарі · TikTok · Reddit | Позначка джерела в картці ідеї; у дайджесті пишемо її словами. |
| matrix-expansion | ідея з таблиці тем | Ідея, складена з комбінації теми й кута без живого сигналу; важить менше за ідею з дзвінка чи реального болю. |
| Topic Authority, Interest Graph, topic cluster | впізнавана тема автора | LinkedIn показує пости тим, кому цікава тема, тому профіль і пости мають тримати одну тему, яку легко зчитати. |
| JTBD | задача клієнта | що людина намагається зробити, коли шукає рішення: «коли…, хочу…, щоб…» |
| viral lever, lever | що змушує реагувати на пост | Причина, через яку люди читають і реагують: особиста історія, суперечлива думка, корисна інструкція тощо. |
<!-- glossary:end -->

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
