# Notion-схема Content Engine

Уся персистентна пам'ять engine живе в Notion. Структура:

```
Content Engine                      ← головна сторінка (workspace hub)
├── 🧭 {Client} · Strategy          ← сторінка на клієнта, 10 секцій (strategy-template.md)
├── 💡 Idea Pool                    ← DB: ідеї всіх клієнтів (фільтр по Client)
├── 📅 Weekly Plans                 ← DB: тижневі плани на затвердження
└── 📊 Posts                        ← DB: опубліковані пости + метрики
```

Перший запуск `01-strategy` створює головну сторінку і DB, якщо їх нема. ID сторінок/data sources
після створення записати у `MEMORY.md` проєкту (щоб не шукати щоразу).

---

## DB «Idea Pool»

| Property | Тип | Значення |
|---|---|---|
| Name | title | робоча назва ідеї (1 рядок) |
| Client | select | Acme, Northwind, … |
| Pillar | select | з секції 7 стратегії клієнта |
| Funnel | select | TOFU / MOFU / BOFU |
| Format | select | text-only / single image / carousel / infographic / lead magnet / video |
| Hook draft | rich_text | чорновий хук (формула: ідея + компетенція) |
| Competence proof | rich_text | чим підкріплена компетенція (число/кейс/досвід) |
| Source | select | research-outlier / call-insight / own-thought / comment-mining / recycle / matrix-expansion |
| Source link | url | лінк на пост-референс / транскрипт / оригінал |
| Score | number | 0–100, рекомендатор |
| Status | select | new → recommended → approved → written → posted → rejected / parked |
| Last used | date | для пауз реюзу (1–3 міс) |
| Notes | rich_text | кут, контекст, чому зараз |

Гейт на вході (3 критерії з methodology §2.1): нема competence proof → ідея не проходить у пул
зі статусом вище `new`.

## DB «Weekly Plans»

| Property | Тип | Значення |
|---|---|---|
| Name | title | «{Client} · Тиждень N (дата-дата)» |
| Client | select | |
| Status | select | draft → sent → approved → in production → done |
| Week start | date | понеділок тижня |

Body сторінки плану: таблиця слотів — день · funnel · формат · **2–3 варіанти ідей** (relation
на Idea Pool) · рядок «чому саме це» на кожен варіант · чекбокс вибору. Після затвердження
вибрані ідеї → Status `approved` в Idea Pool, решта → назад у пул.

## DB «Posts»

| Property | Тип | Значення |
|---|---|---|
| Name | title | хук поста |
| Client | select | |
| Idea | relation | → Idea Pool |
| Pillar / Funnel / Format | select | копія на момент публікації |
| Grader score | number | фінальний total сліпого судді при написанні (06-write крок 8); гейт = ≥ 90 |
| Grader iterations | number | скільки раундів loop до взяття гейта (1 = взяв з першого) |
| Posted date | date | |
| Post URL | url | |
| Angle / Lever | select | кут поста — розріз для калібрування (09-track) |
| Impressions / Likes / Comments / Reposts | number | тижневий інжест (`09-track`); покази лише з AggregateAnalytics XLSX |
| Measured on | date | дата експорту, з якого взяті числа — покази ростуть, без цієї дати порівняння брехливі |
| ER % | formula | (likes+comments+reposts)/impressions |
| RI | number | індекс резонансу проти власної медіани (`tracking-rules.md` §4); порожньо = немає даних |
| Dialogues started | number | ручний інпут або з DM-трекінгу — головний сигнал якості. Порожньо ≠ 0 |
| Leads / Calls | number | атрибуція, ручний інпут |
| Quadrant | select | 💎 самородок / 📣 охоплення без заявок / 🎯 тихий лідоген / ⚪ слабкий (`tracking-rules.md` §5) |
| Performance tier | select | gem / strong / baseline / weak — рахується від медіани АВТОРА, не від абсолютів (§6) |
| Recycle eligible | formula/checkbox | tier ≥ strong І вік ≥ 45–60 днів (конверсія формату) або ≥ 90 днів (републіш) |

## Зв'язки і цикл даних

```
research (03) ──┐
call insights ──┼──> Idea Pool ──> Weekly Plan (04) ──> production (05/06) ──> Posts
recycle (07) ───┘        ↑                                                        │
                         └── ваги в Секцію 7 ← калібрування (09) ← метрики (09) ←──┘
```

- Рекомендатор (04) читає: Idea Pool (Status=new/recommended, пауза по Last used),
  стратегію клієнта (секції 7–8), Posts (performance prior по піларах/темах/кутах).
- `09-track` пише: метрики, RI, квадрант і тір у Posts; відкалібровані ваги — у Секцію 7
  стратегії клієнта (не в reference); переможців — у `07-repurpose`, який кладе recycle-ідеї
  в Idea Pool (Source=recycle).
