# Content Engine

Claude Code plugin: системний LinkedIn-контент для B2B-фаундерів та їхніх клієнтів.
Побудований на методології курсу «LinkedIn Social Selling» Віктора Шульги.

## Ідея

Не «згенеруй мені 60 постів наперед», а **жива система**:

```
01 Strategy ──> Notion-конфіг (ICP, voice, пілари, ритм)
                       │
03 Research ──> Idea Pool (outliers, дзвінки, коменти, рециркуляція)
                       │
04 Weekly Plan ──> 2–3 варіанти на слот, затвердження за 5 хв
                       │
05 Creative → 06 Write ──> карусель/інфографіка, тоді текст у голосі + грейдер
                       │
07 Repurpose · 08 Engage
```

Трекінг (метрики → Posts DB → скоринг тем розумнішає) — окремий тул `linkedin-tracking`,
що живить performance-пріори назад у рекомендатор. Чим довше працює — тим розумніші рекомендації.

## Кроки

| Крок | Що робить | Статус |
|---|---|---|
| `01-strategy` | LinkedIn-стратегія як машиночитний конфіг у Notion (10 секцій) | ✅ v0.1.0 |
| `02-profile-audit` | Аудит профілю (2026) + банер-бриф + Featured-план, прив'язані до стратегії | ✅ v0.3.0 |
| `03-research` | Щотижневий research layer (Fathom + власний потік + outliers + коменти + TikTok + Reddit) → Idea Pool | ✅ v0.2.1 |
| `04-weekly-plan` | Тижневий рекомендатор: 2–3 scored варіанти на слот → Notion + Telegram → затвердження | ✅ v0.4.0 |
| `05-creative` | Креативи: каруселі (7-блочна структура), інфографіки, single image | планується |
| `06-write` | Пост під креатив: хуки → скоринг → драфт у голосі → грейдер | планується |
| `07-repurpose` | Топ-пости за рік → план перевикористання по форматах | планується |
| `08-engage` | Комент-радар по списках ICP/peers + драфти коментарів | планується |

Трекінг (метрики → Posts DB → дашборд + рециркуляція) винесено в окремий тул `linkedin-tracking`.
| `run` | Оркестратор | ✅ |

## Reference

- `reference/methodology.md` — нормативна дистиляція курсу (M1–M6) + viral levers + distribution playbook
- `reference/strategy-template.md` — канон стратегії (10 секцій)
- `reference/hook-bank.md` — правила хуків, 8 типів × 40 зразків, 9 шаблонів, скоринг
- `reference/notion-schema.md` — Idea Pool / Weekly Plans / Posts DB

## Встановлення

```
/plugin marketplace add victor-shulga/content-engine-skills
/plugin install content-engine@content-engine-skills
```

## Валідація

```
bash scripts/validate.sh
```

MIT © Victor Shulga
