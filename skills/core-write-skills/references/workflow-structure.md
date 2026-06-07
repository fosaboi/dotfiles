# Workflow Structure

**Core:** Step-by-step procedures agents can follow.

---

## Step Format

```markdown
## Step N — [Verb] [Object]

[1-sentence purpose]

1. First action
   ```bash
   command1
   ```
2. Second action
   ```bash
   command2
   ```

**Verify:** [success check]

**If [error]:** [solution]
```

---

## Step Naming

**Format:** `Step N — [Verb] [Object]`

```markdown
# ✅ Good
Step 1 — Get Repository Info
Step 2 — Build Project

# ❌ Bad
Step 1 — Repository
Step One — Build
```

---

## Step Granularity

**Rule:** One logical unit per step

| Too Fine | Just Right | Too Coarse |
|----------|------------|------------|
| Click button | Run build | Deploy service |

**Guideline:** Split if >5-7 instructions

---

## Sequencing

### Linear (Most Common)
```
Step 1 → Step 2 → Step 3
```

### Conditional
```markdown
**If [condition]:**
1. Do X
**Else:**
1. Do Y
```

### Branching
```markdown
**If production:** Go to Step 2a
**If staging:** Go to Step 2b
```

**Caution:** Avoid deep nesting

---

## Section Order

```markdown
# Title

[Overview]

## When to Use
## Prerequisites

---
## Step 1
---
## Step 2

---
## Quick Checklist
## Important Notes
## References
```

---

## Checklist

- [ ] Steps sequentially numbered
- [ ] Each step has clear purpose
- [ ] All commands executable
- [ ] Verification included
- [ ] Error handling addressed
