#!/usr/bin/env bash
# validate.sh — structural validation for the content-engine plugin.
#
# Catches the class of bugs that bit us during the 06→13 renumber:
#   - frontmatter `name:` not matching its folder
#   - step numbers in H1 / "Step N" / Notion sub-page titles drifting from the folder
#   - gaps or duplicates in the 01..NN sequence
#   - a step folder that the `run` orchestrator forgot to wire in
#   - YAML-risky descriptions (leading quote / embedded `"` / `: `) — break frontmatter parse
#   - version skew between plugin.json and marketplace.json; invalid JSON
#
# Pure python3 stdlib — no pip deps. Run: bash scripts/validate.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "$ROOT" <<'PY'
import sys, os, re, json, glob

ROOT = sys.argv[1]
errors, warns = [], []
def err(m): errors.append(m)
def warn(m): warns.append(m)

# ---------- 1. JSON validity + version consistency ----------
def load_json(rel):
    p = os.path.join(ROOT, rel)
    try:
        return json.load(open(p, encoding="utf-8"))
    except FileNotFoundError:
        err(f"{rel}: missing"); return None
    except json.JSONDecodeError as e:
        err(f"{rel}: invalid JSON ({e})"); return None

plugin = load_json(".claude-plugin/plugin.json")
market = load_json(".claude-plugin/marketplace.json")
pv = plugin.get("version") if plugin else None
if plugin and not pv:
    err("plugin.json: no version")
if plugin and market:
    mvs = [p.get("version") for p in market.get("plugins", [])]
    if pv not in mvs:
        err(f"version skew: plugin.json={pv} but marketplace.json={mvs}")

# ---------- 2. Per-skill SKILL.md checks ----------
skill_dirs = sorted(d for d in glob.glob(os.path.join(ROOT, "skills", "*")) if os.path.isdir(d))
numbered = []   # (num:int, folder:str)
for d in skill_dirs:
    folder = os.path.basename(d)
    md = os.path.join(d, "SKILL.md")
    if not os.path.isfile(md):
        err(f"{folder}: no SKILL.md"); continue
    txt = open(md, encoding="utf-8").read()

    # frontmatter
    fm = re.match(r"^---\n(.*?)\n---", txt, re.S)
    if not fm:
        err(f"{folder}: no YAML frontmatter (--- ... ---)"); continue
    front = fm.group(1)
    kv = dict(re.findall(r"^([A-Za-z0-9_-]+):[ ](.*)$", front, re.M))

    name = kv.get("name", "")
    if name != folder:
        err(f"{folder}: frontmatter name='{name}' != folder")
    if "displayName" in front:
        err(f"{folder}: 'displayName' key not allowed")

    desc = kv.get("description", "").strip()
    if not desc:
        err(f"{folder}: empty/missing description")
    else:
        if desc[:1] in ('"', "'"):
            err(f"{folder}: description starts with a quote (breaks YAML)")
        if '"' in desc:
            err(f"{folder}: description contains a double-quote (use «» or rephrase)")
        if ': ' in desc:
            err(f"{folder}: description contains ': ' (breaks YAML mapping parse)")

    # numbered-step specific checks
    nm = re.match(r"^(\d{2})-", folder)
    if not nm:
        continue
    num = int(nm.group(1))
    numbered.append((num, folder))

    # H1 like "# 06 · Positioning"
    h1 = re.search(r"^#\s+(\d{2})\s+·", txt, re.M)
    if not h1:
        warn(f"{folder}: no '# NN ·' H1 heading found")
    elif int(h1.group(1)) != num:
        err(f"{folder}: H1 number {h1.group(1)} != folder {nm.group(1)}")

    # "Step N of the Content Engine" in description must match
    sm = re.search(r"Step\s+(\d+)\s+of the Content Engine", desc)
    if sm and int(sm.group(1)) != num:
        err(f"{folder}: description says 'Step {sm.group(1)}' but folder is {num}")

    # Notion sub-page title: first «NN · ...» must match the step number
    nt = re.search(r"«(\d{2})\s+·", txt)
    if nt and int(nt.group(1)) != num:
        err(f"{folder}: Notion sub-page title «{nt.group(1)} ·…» != folder {nm.group(1)}")

# ---------- 3. Sequence integrity ----------
nums = sorted(n for n, _ in numbered)
if nums:
    expected = list(range(1, max(nums) + 1))
    missing = [f"{n:02d}" for n in expected if n not in nums]
    dups = sorted({f"{n:02d}" for n in nums if nums.count(n) > 1})
    if missing: warn(f"sequence gap: step(s) {missing} not built yet (ok if on roadmap)")
    if dups:    err(f"sequence duplicate step number(s) {dups}")
if not os.path.isdir(os.path.join(ROOT, "skills", "run")):
    err("missing orchestrator skill: skills/run")

# ---------- 4. Orchestrator wiring: run/ must reference every numbered step ----------
run_md = os.path.join(ROOT, "skills", "run", "SKILL.md")
if os.path.isfile(run_md):
    run_txt = open(run_md, encoding="utf-8").read()
    for num, folder in numbered:
        if f"content-engine:{folder}" not in run_txt and folder not in run_txt:
            err(f"run/SKILL.md does not reference step '{folder}'")

# ---------- report ----------
print(f"Checked {len(skill_dirs)} skills ({len(numbered)} numbered steps + run).")
for w in warns:
    print(f"  WARN  {w}")
if errors:
    for e in errors:
        print(f"  FAIL  {e}")
    print(f"\n✗ {len(errors)} error(s).")
    sys.exit(1)
print(f"\n✓ All checks passed ({len(warns)} warning(s)). Plugin version: {pv}")
PY
