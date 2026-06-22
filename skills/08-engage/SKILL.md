---
name: 08-engage
description: Step 8 of the Content Engine flow. The comment radar — twice a day, scrapes fresh posts from the author's ICP/peers/influencer lists, drafts a substantive comment per relevant post in the author's voice, and delivers a digest to Telegram for manual posting. Builds Topic Authority and relationships, never auto-comments. Use when the user says комент-радар, що прокоментувати, engage, кого коментувати сьогодні, draft comments, or it is the daily engagement run.
argument-hint: "[client] [--slot=morning|midday]"
---

# 08 · Engage — комент-радар

Восьмий крок. **Гроші в діалогах, не в лайках** (Module 5). Двічі на день дістає свіжі пости зі
списків ICP/peers/інфлюенсерів, драфтить змістовний коментар у голосі автора, шле дайджест у
Telegram. **Тільки драфти — постиш РУКАМИ** (автокоменти = бан-ризик + AI-класифікатор LinkedIn їх ловить).

**Вхід:** `$ARGUMENTS` — клієнт + опц. `--slot` (дефолт обидва: ~9:00 і ~15:00 EET). Каденс: cron
2×/день (коли збудуємо scheduling/n8n).

## Що читаємо
1. **Engage-списки (Notion config):** ICP / peers / інфлюенсери — з Sales Navigator.
   ⚠️ Sales Nav списки = cookie-based: потрібен `li_at` (userConfig) АБО разовий CSV-експорт зі
   Sales Nav. (Це той випадок, де li_at виправданий — на відміну від research.)
2. **Свіжі пости людей зі списків:** Apify `apimaestro/linkedin-profile-posts` (no-cookie) по
   кожному профілю → пости за останні години (slot-вікно). Фільтр: свіжі (в перші ~60 хв ідеально),
   релевантні темі, не реклама/реост.
3. **Стратегія Секція 6 Voice** + `about-viktor` — щоб коментар звучав як автор.
4. **Правила:** `${CLAUDE_PLUGIN_ROOT}/reference/methodology.md` §4 (комент-машина).

## Логіка
- **Мікс 20% ICP / 50% peers / 30% інфлюенсери** (peers — двигун охоплень/комент-мережі).
- **Обсяг:** 5–15 коментів/день сумарно (по слотах).
- **Коментар:** змістовний, **15+ слів, реальна думка/досвід/незгода** — не «great post!».
  Додає інсайт або делікатно челенджить. Жодних AI-патернів (класифікатор ловить → throttle).
- **Пріоритет:** свіжі пости (перші 60 хв) у topic-кластері — це і Topic Authority, і шанс бути
  поміченим автором/його аудиторією (Interest Graph).
- Де доречно — коментар відкриває діалог (probe-питання), не пітч.

## Вихід
1. **Telegram-дайджест** у «LinkedIn Drafts» (коли підключимо токен/n8n): на кожен слот —
   список постів (автор, тип ICP/peer/infl, лінк) + готовий драфт коментаря + чому цей пост.
2. Поки Telegram не підключено — дайджест у чат / Notion.
3. **Зворотний звʼязок у research:** повторювані питання/болі з постів і тредів → сигнал для
   03-research (Source=comment-mining).
4. Summary: скільки драфтів, розподіл міксу, що пропущено.

## Definition of Done
- Списки прочитані (li_at або CSV); свіжі пости зібрані за slot-вікно.
- Драфти у голосі автора, 15+ слів, без AI-патернів; мікс ~20/50/30 дотримано.
- Жодних автокоментів — лише драфти на ручний постинг.
- Дайджест доставлено (Telegram/чат); комент-mining сигнали віддано в research.
