---
name: content-repurpose
description: Step 7 of the Content Engine flow. Mines the author's best-performing posts (backfill of the year's top 30-50, or recent winners from the Posts DB) and proposes how to rebuild each winner into other formats and angles, writing recycle ideas into the Idea Pool. A winning post is a validated idea — repurposing it is the highest-EV content move. Use when the user says перевикористати пости, repurpose, що з топ-постів зробити, найкращі пости за рік, recycle winners, or it is the monthly repurpose run.
argument-hint: "[client] [--backfill | --from-tracking] [--top=30]"
---

# 07 · Repurpose — переможці → нові формати

Сьомий крок. **Пост-переможець = валідована ідея** (резонанс уже доведено) → переробка в інші
формати/кути має найвищий EV. Пише recycle-ідеї в Idea Pool, які далі йдуть звичайним
конвеєром 04→05→06. Це замикає контент-цикл (компаундинг).

**Вхід:** `$ARGUMENTS` — клієнт + режим. **--backfill** (дефолт на старті): скрейп топ-30/50
постів за рік. **--from-tracking** (щомісяця): свіжі переможці з Posts DB.

## Що читаємо
1. **Переможці:**
   - *backfill* — Apify `apimaestro/linkedin-profile-posts` (no-cookie), топ за engagement
     (reactions + 2×comments) за рік; візьми топ `--top` (дефолт 30).
   - *from-tracking* — Posts DB (наповнює `content-track`): `Performance tier` ∈ {gem, strong},
     `Recycle eligible` = true. Пріоритет — квадрант 🎯 «тихий лідоген» (мало охоплення, але дав
     діалоги): переробка сильнішого формату дає найбільше. 📣 «охоплення без заявок» не множимо
     форматом — переписуємо кут під ICP. Posts DB порожній → скажи прямо і йди в `--backfill`.
2. **Стратегія (Notion):** пілари (мапити переробку), voice, офер-драбина (спотити lead-magnet
   кандидатів), факти-патрони.
3. **Правила рециркуляції:** `${CLAUDE_PLUGIN_ROOT}/reference/methodology.md` §2.5а (8 кутів),
   §2.6 (реюз), §4 (конверсія формату 45-60 днів, републіш ≥ 90 днів).

## Terms and plain-language output

<!-- glossary:start terms=repurpose,post-angle,virality-score,republish-pause,performance-tier,post-quadrant,free-hook,idea-pool,content-pillar,tofu-mofu-bofu,weight-calibration -->
Rules for every document a client or their team will read (review, roast, canvas, offer cards, instruction):

1. **Open with «Словник цього документа»**: only the terms that actually appear in it, at most 10, each as «термін: що це простими словами». Like the definitions section of a contract.
2. **No internal codes or letter scales in the text** (A/B/C, D L T E, BLEND numbers without words, Own/Shared/Generic, Z1.4, GATE 2.5, T1–T6). Write the meaning instead: «є цифра з клієнтом», not «A».
3. **Use the plain form from the table below.** English stays only for tool names and for copy that ships in English (promises, hooks, subject lines). If the document is in another language, translate the plain form, never the internal term.
4. **Do not score what cannot exist yet.** A block that depends on work not done (signal catalog, case studies, a previous step) gets «пропущено: спершу потрібно <що саме>», not a score.
5. **Every section of a review opens with one concrete action** («до наступного дзвінка: …»), then at most five lines of why. No paragraph that only restates the framework.


| Internal term (this skill) | Write for the reader | What it means |
|---|---|---|
| repurpose, recycle | переробка поста | Пост, що вже спрацював, переписуємо в іншому форматі чи з іншого боку, бо інтерес до теми вже доведено. |
| angle (Personal story, Lessons, Mistakes, How-I, Listicle, Case, Villain) | кут подачі | З якого боку розказуємо тему: особиста історія, уроки, помилки, як я роблю, список, кейс або суперечка з поширеною думкою. |
| virality score, format_mult × angle_weight × validated_factor | оцінка потенціалу переробки | Число від 0 до 100: наскільки ймовірно, що ця пара формату й кута збере відгук. |
| pause, republish ≥ 90 days, format conversion 45–60 days | пауза перед повтором | Той самий пост повторюємо не раніше ніж через 90 днів, в іншому форматі через 45–60 днів. |
| Performance tier gem / strong, Recycle eligible | рівень поста: найкращий · сильний | Позначка постів, які варто переробити в інший формат; у звіті пишемо словами. |
| quadrant 💎 / 📣 / 🎯 / ⚪ | тип результату поста | Поєднання двох осей: чи пост зібрав відгук і чи розпочав діалоги; від «самородка» до «слабкого». |
| hook / free offer, lead magnet | безкоштовний вхід | аудит, розрахунок втрат або розбір, що показує проблему і веде до розмови |
| Idea Pool | банк ідей | Таблиця в Notion з усіма ідеями для постів, з якої щотижня вибирають теми. |
| pillar, П1–П4 | тема-опора | Одна з 3–5 постійних тем автора; у документі пишемо назву теми словами, без кодів П1–П4. |
| TOFU / MOFU / BOFU, funnel | етап воронки: знайомство · інтерес · рішення | Показує, для кого пост: для тих, хто вас ще не знає, хто вже придивляється, або хто готовий купувати. |
| calibrate, weights, angle_weight, validated_factor | перерахунок пріоритетів за вашими даними | Раз на місяць дивимось, які теми, формати й кути реально заходили, і за цим оцінюємо нові ідеї. |
<!-- glossary:end -->

## Repurpose Matrix (вихід-візуалізація на кожного переможця)
Для кожного переможця будуй **теплокарту кути × формати** з virality-скором у клітинці
(HTML-віджет через visualize, бренд-нод корал; легенда + топ-5 ходів унизу).
- **Рядки (кути, з пост-генератора / framework):** Personal story · Lessons · Mistakes · How-I ·
  Listicle · Case/social proof · Villain/contrarian.
- **Колонки (формати):** Карусель · Лід-магніт · Інфографіка · Newsletter · Single image · Крос-пост.
- **Score клітинки = round(100 × format_mult × angle_weight × validated_factor):**
  - `format_mult` (van der Blom 2026 ER): карусель/документ **1.0** · лід-магніт **0.95** (giveaway-lever)
    · інфографіка **0.9** · newsletter **0.6** · single image **0.55** · крос-пост **0.5**.
  - `angle_weight` — viral lever, **калібрований на даних автора** (`content-track --mode=calibrate`,
    Секція 7 стратегії) (у Viktor personal/vulnerability б'є
    теорію): підбирай ваги під ДНК конкретного переможця (для personal-winner: Personal 1.0,
    Lessons/Mistakes 0.9, How-I 0.8, Listicle 0.65, Case 0.6, Villain 0.55).
  - `validated_factor` — перформанс-перцентиль оригіналу (топ-1 ≈ 0.95).
- **Паузи (відсікти):** клітинка-оригінал = републіш (тільки ≥ 90 днів); конверсія формату ≥ 45-60 днів.
- **Топ-N клітинок → recycle-картки.** «Same format / suміжна тема» — окремий рядок-нотатка
  (республіш ≥90д або сусідній кут тієї ж теми).

## Вихід
1. **Repurpose Matrix** (теплокарта) на кожного топ-переможця — для перегляду й вибору.
2. Recycle-картки в **💡 Idea Pool** (з обраних/топ клітинок): `Source = recycle` · `Source link` =
   URL оригіналу · `Last used` = дата оригіналу (щоб працювали паузи) · `Notes` = «що виграло + яка
   переробка (кут×формат, score)» · pillar/funnel/format нової версії · Score з матриці.
3. **Дайджест:** топ-переможці + матриці; що відсіяно за паузою.
4. Summary оркестратору (картки готові для content-weekly-plan).

## Definition of Done
- Переможці зібрані (backfill scrape або Posts DB winners); ранжовані за engagement.
- Кожен має 2-4 переробки з матриці; паузи (45-60д конверсія / ≥90д републіш) дотримані.
- Recycle-картки в Idea Pool з лінком на оригінал і Last used = дата оригіналу.
- Lead-magnet кандидати (фреймворк-пости) позначені окремо (розблоковують giveaway).
- Дайджест показано; дублі проти наявного пулу не створені.
