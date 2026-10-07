# Content Engine

Claude Code plugin: системний LinkedIn-контент для B2B-фаундерів та їхніх клієнтів.
Побудований на методології курсу «LinkedIn Social Selling» Віктора Шульги.

## Ідея

Не «згенеруй мені 60 постів наперед», а **жива система**:

```
01 Strategy ──> Notion-конфіг (ICP, voice, пілари, ритм)
                       │
03 Research ──> Idea Pool (Fathom, LinkedIn, TikTok, Reddit, коменти, власний потік)
                       │
04 Weekly Plan ──> 2–3 варіанти на слот, затвердження за 5 хв
                       │
05 Creative → 06 Write ──> карусель/інфографіка, тоді текст у голосі + грейдер
                       │
07 Repurpose · 08 Engage
                       │
09 Track ──> метрики → тіри → ваги назад у Секцію 7 ──┐
                       └──────────────────────────────┘
```

Цикл замикається: `content-track` міряє опубліковане й повертає ваги в рекомендатор.
Чим довше система працює — тим розумніші рекомендації.

## Кроки

| Крок | Що робить | Статус |
|---|---|---|
| `content-linkedin-strategy` | LinkedIn-стратегія як машиночитний конфіг у Notion (10 секцій) | ✅ v0.1.0 |
| `content-profile-audit` | Аудит профілю (2026) + банер-бриф + Featured-план, прив'язані до стратегії | ✅ v0.3.0 |
| `content-research` | Щотижневий research layer (Fathom + власний потік + LinkedIn + коменти + TikTok + Reddit) → Idea Pool | ✅ v0.2.1 |
| `content-weekly-plan` | Тижневий рекомендатор: 2–3 scored варіанти на слот → Notion + Telegram → затвердження | ✅ v0.4.0 |
| `content-creative` | Креативи: каруселі (7-блочна), інфографіки, single image — роутер над дизайн-скілами | ✅ v0.6.0 |
| `content-write` | Пост під креатив: голос → хук → фреймворк → humanize → **grade gate** (сліпий суддя, рубрика, loop до ≥90) | ✅ v0.8.0 |
| `content-repurpose` | Переможці (топ за рік / Posts DB) → переробка в нові формати/кути → Idea Pool | ✅ v0.8.0 |
| `content-engage` | Комент-радар у 3 режимах: `targets` (4 аудиторії зі стратегії → boolean-пошук → список профілів) · `radar` (свіжі пости → відбір → драфти коментарів) · `log` (факт + комент-майнінг назад у research). Постинг завжди ручний | ✅ v0.10.0 |
| `content-track` | Трекінг у 3 режимах: `ingest` (експорти LinkedIn → архів + Posts DB) · `score` (резонанс проти власної медіани × діалоги → квадрант, тір, дайджест, дашборд) · `calibrate` (розрізи → ваги в Секцію 7 стратегії). Замикає цикл | ✅ v0.11.0 |
| `content-run` | Оркестратор | ✅ |

## Reference

- `reference/methodology.md` — нормативна дистиляція курсу (M1–M6) + viral levers + distribution playbook
- `reference/strategy-template.md` — канон стратегії (10 секцій)
- `reference/hook-bank.md` — правила хуків, 8 типів × 40 зразків, 9 шаблонів, скоринг
- `reference/notion-schema.md` — Idea Pool / Weekly Plans / Posts DB
- `reference/engage-playbook.md` — комент-радар: 4 аудиторії, boolean-рецепти, драбина каналів пошуку, гейти відбору поста, 7 типів коментарів, гейт якості
- `reference/tracking-rules.md` — вимірювання: джерела й їхні межі, бейзлайн автора, індекс резонансу, квадранти (резонанс × діалоги), тіри, n-гейт калібрування
- `reference/grader-rubric.md` — QA-гейт драфту (сліпий суддя, 100-бальна рубрика, loop-until-gate); калібрується з winners/flops

## Встановлення

```
/plugin marketplace add victor-shulga/content-engine-skills
/plugin install content-engine@content-engine-skills
```

**Оновлення зі старої версії (номери в назвах, до 0.12.0).** 07.10.2026 кроки отримали імена з префіксом паку
замість номерів: `01-strategy` → `content-linkedin-strategy`, `02-profile-audit` → `content-profile-audit`,
`03-research` → `content-research`, `04-weekly-plan` → `content-weekly-plan`, `05-creative` → `content-creative`,
`06-write` → `content-write`, `07-repurpose` → `content-repurpose`, `08-engage` → `content-engage`,
`09-track` → `content-track`. Порядок кроків той самий, його веде `content-run`. Щоб оновитися, запустіть ту саму
команду встановлення ще раз (`npx skills add victor-shulga/content-engine-skills` або
`/plugin marketplace update content-engine-skills`). Старі теки `01-strategy` … `09-track` у `~/.claude/skills/`
можна видалити.

## Валідація

```
bash scripts/validate.sh
```

MIT © Victor Shulga / Victor Shulga
