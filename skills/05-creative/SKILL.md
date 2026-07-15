---
name: 05-creative
description: Step 5 of the Content Engine flow (creative-first). Takes an approved Idea Pool card and produces the visual creative — carousel, infographic, single image, or lead-magnet — in the client brand, routing to the existing design skills. Runs BEFORE the post text (06-write). Use when the user says зроби креатив, креатив для поста, карусель/інфографіка для ідеї, design the creative, or it is the creative step for an approved idea.
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
- **carousel** → виклич `linkedin-carousel`. Контент слайдів збудуй з ідеї за 7-блочною структурою
  (обкладинка=хук → контекст → 1 думка/слайд → результати=proof → бонус → CTA).
- **infographic** → виклич `infographic`. Заголовок ВЕРХНІМ РЕГІСТРОМ по центру; chart > text-grid
  (Donut/Funnel/Growth Curve/Timeline); коралова підсвітка = білий текст; фон лише білий.
- **single image** → personal/TOFU: власне фото автора; expertise: брендований stat/quote-візуал
  (хук+цифра, автор-блок, вордмарк).
- **lead magnet** → робочий темплейт → PDF (не чеклист). Це також розблоковує giveaway-середи.
- **text-only** → креатив не потрібен: познач і передай одразу в 06-write.
- **video** → поза автоматизацією: познач ручний крок.

## Бренд (інваріант)
Viktor/Victor Shulga — білий фон + корал #E85A4F + Inter Tight/Inter + автор-блок + вордмарк.
Клієнти — їхній бренд-кіт. НІКОЛИ не мішати корал Victor Shulga у клієнтські креативи.

## Вихід
1. Креатив у Figma (+ inline-скріни кожного слайда/візуала для перегляду).
2. Прикріпити креатив до картки/поста; для каруселі — зберегти драфт контенту слайдів.
3. Передати в **06-write**: готовий візуал + (для каруселі) контент слайдів, щоб текст писався ПІД нього.
4. Короткий summary: що зроблено, формат, лінк на Figma, що далі (06-write).

## Definition of Done
- Формат визначено з картки; роутинг відпрацював (або text-only/video коректно пропущено).
- Креатив у бренді клієнта (Viktor — білий фон+корал; правила інфографіки дотримані).
- Карусель — рівно 7 блоків, 1 думка/слайд; цифри з фактів-патронів, не вигадані.
- Креатив прикріплено; передано в 06-write з усім потрібним; summary повернуто.
