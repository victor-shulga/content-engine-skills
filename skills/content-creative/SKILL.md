---
name: content-creative
description: Step 5 of the Content Engine flow (creative-first). Takes an approved Idea Pool card and produces the visual creative — carousel, infographic, single image, or lead-magnet — in the client brand, routing to the linkedin-creative skill with the client brand file (older design skills only as a fallback for the author's own brand). Runs BEFORE the post text (content-write). Use when the user says зроби креатив, креатив для поста, карусель/інфографіка для ідеї, design the creative, or it is the creative step for an approved idea.
argument-hint: "<idea-name-or-id> [client]"
---

# 05 · Creative — креатив першим

П'ятий крок (після свапу — креатив ПЕРЕД текстом: креатив стопить скрол, текст його підтримує).
Бере затверджену картку Idea Pool і збирає візуал у бренді клієнта. **Не генератор з нуля — роутер
над наявними дизайн-скілами** за правилами `${CLAUDE_PLUGIN_ROOT}/reference/creative-rules.md`.

**Вхід:** `$ARGUMENTS` — ідея (`Status=approved` з Idea Pool) + клієнт. Якщо ідея не approved —
запитай, чи брати її все одно (напр. реактивний пост).

## Що читаємо
1. **Картку Idea Pool:** hook draft · format · pillar · competence proof · notes · source link
   (для outlier — скрін-референс «як подано»).
2. **Стратегію (Notion):** voice, signature, факти-патрони (для цифр на креативі), бренд клієнта.
3. **Правила:** `creative-rules.md` (формат-роутинг, інфографіка, single-image, бренд) +
   `methodology.md` §3.6 (карусель 7 блоків).

## Роутинг за форматом (creative-rules.md)
**Основний шлях — скіл `linkedin-creative`** (якщо встановлений): один вхід на інфографіку, карусель
і лід-магніт у будь-якому бренді. Виклич його з **бренд-файлом клієнта** (JSON у теці клієнта,
напр. `./brand/<company>.json`). Бренд-файлу нема — спершу збери його за `references/brand-kit.md`
того скіла (~5 хв) і збережи поруч з роботою клієнта. Рендер — PNG/PDF через headless Chrome
з перевіркою верстки (`qa()` має сказати `ok: True`).

Скіли `linkedin-carousel` та `infographic` — **лише запасний шлях для бренду Victor Shulga**
(вони прибиті до його бренду й Figma). Для клієнтів їх не використовуй.
Не встановлено жодного — зверстай сам 1080×1350 за `creative-rules.md` (HTML або Figma).

- **carousel** → `linkedin-creative` (формат carousel: PNG на слайд + `slides.pdf` для завантаження).
  Контент слайдів збудуй з ідеї за 7-блочною структурою
  (обкладинка=хук → контекст → 1 думка/слайд → результати=proof → бонус → CTA).
- **infographic** → `linkedin-creative` (формат infographic, 1 PNG): форму обери з його
  `references/shapes.md`, не ту саму, що в попередньому креативі. Без скіла тримай ротацію сам:
  форма не повторюється двічі поспіль і не частіше двох разів на п'ять креативів.
  Шляхів до чужих скілів тут нема навмисно: нічого не запускай за шляхом, якого не
  перевірив у теці встановленого скіла. Дефолт лишається chart > text-grid, коли в даних є
  форма (частка, спад по етапах, зміна в часі); коралова підсвітка = білий текст; фон лише білий.
- **single image** → personal/TOFU: власне фото автора; expertise: брендований stat/quote-візуал
  (хук+цифра, автор-блок, вордмарк).
- **lead magnet** → `linkedin-creative` (формат lead magnet: обкладинка з комент-гейтом +
  сам магніт A4 PDF). Магніт — робочий темплейт, не чеклист; лід-магніт ніколи не карусель.
  Лід-магніт і комент-гейт живуть ТІЛЬКИ в четверговому слоті; у решті днів фінал поста — директив.
- **text-only** → креатив не потрібен: познач і передай одразу в content-write.
- **video** → поза автоматизацією: познач ручний крок.

## Бренд (інваріант)
Viktor — білий фон + корал #E85A4F + Inter Tight/Inter + автор-блок + вордмарк.
Клієнти — їхній бренд-кіт. НІКОЛИ не мішати корал персонального бренду у клієнтські креативи.

## Вихід
1. Креатив: PNG/PDF з `linkedin-creative` (або Figma на запасному шляху) + inline-скріни кожного
   слайда/візуала для перегляду.
2. Прикріпити креатив до картки/поста; для каруселі — зберегти драфт контенту слайдів.
3. Передати в **content-write**: готовий візуал + (для каруселі) контент слайдів, щоб текст писався ПІД нього.
4. Короткий summary: що зроблено, формат, шлях до файлів / лінк на Figma, що далі (content-write).

## Definition of Done
- Формат визначено з картки; carousel/infographic/lead magnet пішли в `linkedin-creative` з бренд-файлом клієнта
  (якщо скіл встановлено); роутинг відпрацював (або text-only/video коректно пропущено).
- Креатив у бренді клієнта (Viktor — білий фон+корал; правила інфографіки дотримані).
- Карусель — рівно 7 блоків, 1 думка/слайд; цифри з фактів-патронів, не вигадані.
- Креатив прикріплено; передано в content-write з усім потрібним; summary повернуто.
