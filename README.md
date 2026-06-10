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
05 Write + 06 Creative ──> хук-скоринг, голос автора, грейдер, карусель/інфографіка
                       │
07 Track ──> метрики у Posts DB ──> скоринг тем розумнішає ──> назад в Idea Pool
```

Чим довше працює — тим розумніші рекомендації (performance-пріори по піларах і темах).

## Кроки

| Крок | Що робить | Статус |
|---|---|---|
| `01-strategy` | LinkedIn-стратегія як машиночитний конфіг у Notion (10 секцій) | ✅ v0.1.0 |
| `02-profile-audit` | Аудит профілю + банер + featured | планується |
| `03-research` | Щотижневий research layer → Idea Pool | планується |
| `04-weekly-plan` | Тижневий рекомендатор тем | планується |
| `05-write` | Продакшн: хуки → скоринг → драфт → грейдер | планується |
| `06-creative` | Каруселі (жорстка 7-блочна структура), інфографіки | планується |
| `07-track` | Інжест метрик + місячна рециркуляція | планується |
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
