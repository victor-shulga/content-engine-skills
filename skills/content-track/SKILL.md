---
name: content-track
description: Step 9 of the Content Engine flow. The tracking loop that closes the compound cycle — ingests LinkedIn analytics exports into the post archive and the Posts DB, scores every post on two axes (resonance against the author own median, and dialogues started), tags winners as gem or strong so content-repurpose can run from tracking, and once a month calibrates pillar, format and angle weights back into the client strategy that the weekly recommender reads. Use when the user says трекінг, інжест метрик, як зайшли пости, що спрацювало, оновити дашборд, відкалібруй ваги, track posts, ingest analytics, or it is the weekly metrics run.
argument-hint: "[client] [--mode=ingest|score|calibrate] [--metrics=<xlsx...>] [--since=YYYY-MM-DD]"
---

# 09 · Track — метрики → пріори

Дев'ятий крок і **замикання циклу**. Без нього рекомендатор скорить наосліп, а `content-repurpose`
не має звідки взяти переможців. Логіка проста: опубліковані пости → числа → тіри → ваги назад
у стратегію, яку читає `content-weekly-plan`.

| Режим | Що робить | Каденс |
|---|---|---|
| `--mode=ingest` | експорти LinkedIn → архів `posts.jsonl` → Posts DB | щотижня |
| `--mode=score` *(дефолт)* | бейзлайн, індекс резонансу, квадранти, тіри, дайджест, дашборд | щотижня |
| `--mode=calibrate` | розрізи по піларах/форматах/кутах → ваги в Секцію 7 стратегії | щомісяця |

**Нормативка:** `${CLAUDE_PLUGIN_ROOT}/reference/tracking-rules.md` — джерела й їхні межі,
бейзлайн, формула RI, квадранти, тіри, n-гейт калібрування, гейти чесності. Читати ПЕРЕД
будь-яким режимом. Додатково `methodology.md` §6 (піраміда метрик, каденси, правило фідбеку),
§2.6 (паузи реюзу), §4 п.11 (день 3/7/10).

**Вхід:** `$ARGUMENTS` — клієнт (дефолт — єдиний активний) + прапорці.
**Стан:** архів клієнта (`archive/posts.jsonl` + `ANGLES.md`) у робочій теці, не в репо плагіна.

---

## Режим A · `--mode=ingest` — зібрати числа

### A1 · Взяти експорти
Три файли, усі з LinkedIn, усі — руками користувача (автоматично не дістаються):
- **AggregateAnalytics XLSX** — профіль → Analytics → Export. Покази й взаємодії. Тримає
  **топ-50 за своє вікно** → просити файл на кожен квартал, інакше рік не покритий.
- **Shares.csv** — повний текст постів (LinkedIn data export, лист за ~24 год).
- **Rich_Media.csv** — формат поста.

Нема свіжого XLSX → не блокуйся: інжест тексту й форматів іде, охоплення лишається порожнім,
у звіті це видно окремим рядком.

### A2 · Прогнати архів
Скрипт лежить у теці цього скіла: `<тека скіла content-track>/scripts/build_archive.py`. Запускай
саме його, з робочої теки автора (там чернетки `*.md` і `archive/`):
```
python3 <тека скіла content-track>/scripts/build_archive.py --root . --metrics <q1.xlsx> <q2.xlsx> --shares Shares.csv --media Rich_Media.csv
```
Для `--metrics` потрібен `openpyxl` (`pip install openpyxl`). Шлях до теки скіла визнач
перед запуском (`find ~ -path "*content-track/scripts/build_archive.py" 2>/dev/null`) і покажи
користувачу; файл з такою назвою в іншому місці не запускай.
Скрипт зливає джерела за share id, **ручну класифікацію не чіпає** (кут, рубрика, теми, формат,
воронка). Вихід — `archive/posts.jsonl` + індекс `ANGLES.md`.

### A3 · Добити ручні поля
Після прогону скрипт друкує, скільки постів без кута. Класифікуй нові пости (кут, рубрика,
теми) — без цього калібрування не має розрізів.

### A4 · Діалоги
Головна вісь, і вона нізвідки не приходить сама. По кожному новому посту одним питанням:
скільки діалогів він розпочав (DM, коменти-у-приват, вхідні). Не знаєш — лишай **порожнім**,
не нулем. Ліди й дзвінки — туди ж, якщо є атрибуція.

### A5 · У Notion
Записати/оновити рядки в **📊 Posts** (`reference/notion-schema.md`): хук, дата, URL, пілар,
воронка, формат, кут, покази, лайки/коменти/репости, діалоги, ліди, дата експорту.

---

## Режим B · `--mode=score` — що з цього спрацювало

1. **Бейзлайн — ковзний** (`tracking-rules.md` §3): для кожного поста медіана 12 постів,
   опублікованих ДО нього. Загальна медіана на весь архів — помилка: на реальних даних вона
   зробила переможцями 65% постів. Самоперевірка — медіана RI по архіву ≈ 1.0. Менше 6
   попередніх постів з даними → тіри не ставимо, показуємо сирі числа й кажемо чому.
2. **RI** на кожен пост за `tracking-rules.md` §4. Без показів — тільки вісь ER + прапорець.
3. **Квадрант** (§5) — 💎 самородок · 📣 охоплення без заявок · 🎯 тихий лідоген · ⚪ слабкий.
   Діалоги невідомі → квадрант не ставиться, лише тір по RI з прапорцем.
4. **Тір і право на рециркуляцію** (§6) → у Posts DB. Це те, що потім читає
   `content-repurpose --from-tracking`.
5. **Дайджест** (Telegram, той самий канал, що й тижневий план):
   - top-3 and bottom-3 posts of the week, each with its resonance said in words (e.g. «у 2,1 раза більше відгуку, ніж зазвичай») and the quadrant name, never a bare RI number;
   - рядок покриття «покази по N з M постів»;
   - 🎯 тихі лідогени окремим блоком — це кандидати на переробку №1;
   - 1–3 рядки «що це означає для наступного тижня» (без нових ваг — ваги ставить режим C).
6. **Дашборд** — перебудувати сторінку клієнта з архіву й задеплоїти. Для персонального бренду
   автора це один HTML з вшитими даними + деплой на Cloudflare Pages; шлях і проєкт беруться
   з конфіга клієнта, не вигадуються.

---

## Режим C · `--mode=calibrate` — числа → ваги

Раз на місяць, і тільки коли назбиралась вибірка.

1. Розрізи: **пілар · формат · кут (важіль) · тип хука · довжина · день тижня**.
2. По кожному сегменту — медіанний RI проти загальної медіани, формула ваги й **n-гейт**
   (`tracking-rules.md` §8): n ≥ 4 → вага; n = 2–3 → «сигнал, не висновок»; n ≤ 1 → мовчимо.
3. Записати в **Секцію 7 стратегії** клієнта таблицю відкаліброваних важелів з `n` і датою.
   Далі `content-weekly-plan` бере їх автоматично на кроці скору.
4. Оновити `angle_weight` і `validated_factor` для `content-repurpose`.
5. Переможців і провали віддати в `grader-rubric.md` як приклади калібрування судді.
6. Дефолтну таблицю важелів `methodology.md` §5 **не чіпати** — це стартова гіпотеза для
   нового клієнта, а не місце для даних конкретного.

---

## Definition of Done

- Експорти інжестнуті, архів перебудований, ручна класифікація не затерта.
- Діалоги запитані по кожному новому посту; невідоме лишилось порожнім, не нулем.
- Posts DB оновлено; кожен пост із даними має RI, квадрант, тір і право на рециркуляцію.
- Дайджест показано з рядком покриття; 🎯 тихі лідогени винесені окремо.
- Дашборд перебудовано й задеплоєно (або сказано, чому пропущено).
- У режимі калібрування — Секція 7 оновлена тільки по сегментах з n ≥ 4; решта позначена
  як сигнал; `content-repurpose --from-tracking` після цього має з чого працювати.

## Terms and plain-language output

<!-- glossary:start terms=resonance-index,engagement-rate,rolling-baseline,post-quadrant,performance-tier,n-gate,weight-calibration,content-pillar,post-angle,viral-lever,repurpose -->
Rules for every document a client or their team will read (review, roast, canvas, offer cards, instruction):

1. **Open with «Словник цього документа»**: only the terms that actually appear in it, at most 10, each as «термін: що це простими словами». Like the definitions section of a contract.
2. **No internal codes or letter scales in the text** (A/B/C, D L T E, BLEND numbers without words, Own/Shared/Generic, Z1.4, GATE 2.5, T1–T6). Write the meaning instead: «є цифра з клієнтом», not «A».
3. **Use the plain form from the table below.** English stays only for tool names and for copy that ships in English (promises, hooks, subject lines). If the document is in another language, translate the plain form, never the internal term.
4. **Do not score what cannot exist yet.** A block that depends on work not done (signal catalog, case studies, a previous step) gets «пропущено: спершу потрібно <що саме>», not a score.
5. **Every section of a review opens with one concrete action** («до наступного дзвінка: …»), then at most five lines of why. No paragraph that only restates the framework.


| Internal term (this skill) | Write for the reader | What it means |
|---|---|---|
| RI, resonance index | відгук порівняно зі звичайним | У скільки разів пост зібрав більше чи менше реакцій, ніж попередні пости автора; 1 означає як завжди. |
| ER, engagement rate | частка реакцій від показів | Скільки людей з тих, хто побачив пост, лайкнули, прокоментували чи поширили. |
| baseline, rolling median | звичайний рівень автора | Типовий результат 12 попередніх постів, з яким порівнюємо кожен новий пост. |
| quadrant 💎 / 📣 / 🎯 / ⚪ | тип результату поста | Поєднання двох осей: чи пост зібрав відгук і чи розпочав діалоги; від «самородка» до «слабкого». |
| Performance tier gem / strong, Recycle eligible | рівень поста: найкращий · сильний | Позначка постів, які варто переробити в інший формат; у звіті пишемо словами. |
| n-gate, n ≥ 4 | мінімум постів для висновку | Висновок про тему чи формат робимо від 4 постів; 2–3 пости дають лише сигнал. |
| calibrate, weights, angle_weight, validated_factor | перерахунок пріоритетів за вашими даними | Раз на місяць дивимось, які теми, формати й кути реально заходили, і за цим оцінюємо нові ідеї. |
| pillar, П1–П4 | тема-опора | Одна з 3–5 постійних тем автора; у документі пишемо назву теми словами, без кодів П1–П4. |
| angle (Personal story, Lessons, Mistakes, How-I, Listicle, Case, Villain) | кут подачі | З якого боку розказуємо тему: особиста історія, уроки, помилки, як я роблю, список, кейс або суперечка з поширеною думкою. |
| viral lever, lever | що змушує реагувати на пост | Причина, через яку люди читають і реагують: особиста історія, суперечлива думка, корисна інструкція тощо. |
| repurpose, recycle | переробка поста | Пост, що вже спрацював, переписуємо в іншому форматі чи з іншого боку, бо інтерес до теми вже доведено. |
<!-- glossary:end -->
