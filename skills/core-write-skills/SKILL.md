---
name: skills-how-to
description: >-
  Guide for creating concise, clear, and straightforward SKILL.md files.
  Skills must be concise, clear, and straightforward.
  Use when creating or reviewing skills. Triggers on: "create a skill", "write SKILL.md".
---

# How to Write Skills

**CORE PRINCIPLE: Skills must be concise, clear, and straightforward.**

Agents need **actionable workflows**, not reference manuals. Every word should serve a purpose.

## When to Use
- Creating a new skill
- Reviewing/improving existing skills

---

## Requirements

| Must Have | Description |
|-----------|-------------|
| Clear activation | When to use/when NOT to use |
| Actionable workflow | Step-by-step procedures |
| Executable examples | Code blocks agents can run |
| Self-contained | All info in skill or linked references |

---

## Step 1 — Define Skill

**Frontmatter:**
```yaml
---
name: skill-name
description: >-
  What it does + when to use.
  Triggers on: "phrase1", "phrase2"
  Do NOT use for: case1
argument-hint: "[arg] | e.g., value"
---
```

**Naming:** kebab-case (`my-skill-name`)

---

## Step 2 — Structure

```markdown
# Title: $ARGUMENTS
You are [verb] that [does what].

## When to Use
- Use when: [condition]
- Do NOT use when: [anti-condition]

## Prerequisites
- Tool installed
- Access required

---
## Step 1 — [Verb] [Object]
[Purpose]
```bash
command
```
**Verify:** check

---
## Quick Checklist
- [ ] All steps complete
```

---

## Step 3 — Write Content

### Voice
```markdown
# ✅ DO
Check status
Run command

# ❌ DON'T
You should check
Please run
```

### Step Format
```markdown
## Step N — [Verb] [Object]
[Purpose]
1. Action
   ```bash
   command
   ```
**Verify:** check
**If error:** fix
```

### Examples
Every step needs an executable example.

---

## Step 4 — Validate

**Before Publishing:**
- [ ] Frontmatter complete
- [ ] Activation criteria clear
- [ ] Workflow step-by-step
- [ ] All commands copy-pasteable
- [ ] Examples executable
- [ ] No assumed knowledge

**Test:** Can someone follow this without asking questions?

---

## Mistakes to Avoid

| Mistake | Fix |
|---------|-----|
| Vague | "Run X" not "You should run X" |
| No examples | Add executable example |
| No workflow | Add numbered steps |
| Unclear triggers | Define when to use |

---

## References
- [Activation Criteria](references/activation-criteria.md)
- [Workflow Structure](references/workflow-structure.md)
- [Content Patterns](references/content-patterns.md)
- [Examples & Testing](references/examples-and-testing.md)
