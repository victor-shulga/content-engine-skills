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

## Для кожного переможця
1. **Чому виграв:** хук-тип, пілар, формат, який viral lever (це визначає, що тиражувати).
2. **Запропонуй 2-4 ходи переробки** (з матриці нижче), дотримуючись пауз:
   - **Зміна формату** (конверсія, ≥ 45-60 днів від оригіналу): text/single → **карусель**
     (розгорнути фреймворк у слайди) · пост → **інфографіка** (візуалізувати цифру/фреймворк) ·
     фреймворк-пост → **лід-магніт** (продуктизувати в PDF — заодно розблоковує giveaway) ·
     лонгформ → **newsletter/article** (SEO/GEO).
   - **Зміна кута** (8 обігравань §2.5а): How-I / villain / mistakes / lessons-версія тієї ж ідеї.
   - **Републіш** (≥ 90 днів): той самий пост з оновленим хуком.
   - **Крос-платформа:** TikTok / Reddit / X (зерно для тих каналів).
3. **Скор:** високий базовий (валідовано результатом) × format-fit × свіжість паузи. Республіш
   < 90 днів або конверсія < 45 днів — НЕ пропонувати (відсікти).

## Вихід
1. Recycle-картки в **💡 Idea Pool**: `Source = recycle` · `Source link` = URL оригіналу ·
   `Last used` = дата оригіналу (щоб працювали паузи) · `Notes` = «що виграло + яка переробка» ·
   pillar/funnel/format нової версії · Score.
2. **Дайджест:** топ-переможці + запропоновані переробки на кожен; що відсіяно за паузою.
3. Summary оркестратору (картки готові для 04-weekly-plan).

## Definition of Done
- Переможці зібрані (backfill scrape або Posts DB winners); ранжовані за engagement.
- Кожен має 2-4 переробки з матриці; паузи (45-60д конверсія / ≥90д републіш) дотримані.
- Recycle-картки в Idea Pool з лінком на оригінал і Last used = дата оригіналу.
- Lead-magnet кандидати (фреймворк-пости) позначені окремо (розблоковують giveaway).
- Дайджест показано; дублі проти наявного пулу не створені.
