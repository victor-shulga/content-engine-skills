---
name: 07-repurpose
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
   - *from-tracking* — Posts DB: `Performance tier` ∈ {gem, strong}, `Recycle eligible` = true.
2. **Стратегія (Notion):** пілари (мапити переробку), voice, офер-драбина (спотити lead-magnet
   кандидатів), факти-патрони.
3. **Правила рециркуляції:** `${CLAUDE_PLUGIN_ROOT}/reference/methodology.md` §2.5а (8 кутів),
   §2.6 (реюз), §4 (конверсія формату 45-60 днів, републіш ≥ 90 днів).

## Repurpose Matrix (вихід-візуалізація на кожного переможця)
Для кожного переможця будуй **теплокарту кути × формати** з virality-скором у клітинці
(HTML-віджет через visualize, бренд-нод корал; легенда + топ-5 ходів унизу).
- **Рядки (кути, з пост-генератора / framework):** Personal story · Lessons · Mistakes · How-I ·
  Listicle · Case/social proof · Villain/contrarian.
- **Колонки (формати):** Карусель · Лід-магніт · Інфографіка · Newsletter · Single image · Крос-пост.
- **Score клітинки = round(100 × format_mult × angle_weight × validated_factor):**
  - `format_mult` (van der Blom 2026 ER): карусель/документ **1.0** · лід-магніт **0.95** (giveaway-lever)
    · інфографіка **0.9** · newsletter **0.6** · single image **0.55** · крос-пост **0.5**.
  - `angle_weight` — viral lever, **калібрований на даних автора** (у Viktor personal/vulnerability б'є
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
4. Summary оркестратору (картки готові для 04-weekly-plan).

## Definition of Done
- Переможці зібрані (backfill scrape або Posts DB winners); ранжовані за engagement.
- Кожен має 2-4 переробки з матриці; паузи (45-60д конверсія / ≥90д републіш) дотримані.
- Recycle-картки в Idea Pool з лінком на оригінал і Last used = дата оригіналу.
- Lead-magnet кандидати (фреймворк-пости) позначені окремо (розблоковують giveaway).
- Дайджест показано; дублі проти наявного пулу не створені.
