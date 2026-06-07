---
name: data-integrity
description: >-
  Prevent data corruption through defensive programming.
  Guards against null values, division by zero, and type mismatches.
  Triggers on: "null safety", "data validation", "defensive", "guard"
---

# Data Integrity

**Core Principle:** Treat all external data as potentially invalid. Guard every operation.

## When to Use
- Processing data from APIs, databases, or user input
- Aggregating values (sums, averages, counts)
- Before accessing object properties

---

## Step 1 — Null Safety

**Null ≠ 0.** Null means "unknown/missing", not "zero".

```typescript
// ❌ WRONG - corrupts aggregations
entry.sum += value ?? 0
entry.count += 1

// ✅ CORRECT - skip nulls, track counts separately
if (value != null) {
  entry.sum += value
  entry.count += 1
}
```

**Example:** Aggregating `[3.5, null, 4.0]`
- Wrong: `(3.5 + 0 + 4.0) / 3 = 2.5` (33% error!)
- Correct: `(3.5 + 4.0) / 2 = 3.75`

---

## Step 2 — Defensive Division

**Always guard against division by zero.**

```typescript
// ❌ WRONG - crashes if count is 0
const average = sum / count

// ✅ CORRECT
const average = count > 0 ? sum / count : 0
```

**Why:** Future code changes might introduce zero-count scenarios.

---

## Step 3 — Type Guards

**Validate types before operations.**

```typescript
// ❌ WRONG - crashes if not array
const length = data.points.length

// ✅ CORRECT - guard first
if (data && Array.isArray(data.points)) {
  const length = data.points.length
}
```

---

## Step 4 — Composite Keys

**Coalesce all nullable components.**

```sql
-- ❌ WRONG - NULL key if any component is NULL
unique_key = "quarter || '-' || coalesce(region, 'Unknown')"

-- ✅ CORRECT - coalesce ALL components
unique_key = "coalesce(quarter, 'Unknown') || '-' || coalesce(region, 'Unknown')"
```

**Why:** NULL in any part creates a NULL composite key, causing duplicate inserts.

---

## Quick Checklist
- [ ] Null values handled explicitly (not coerced to 0)
- [ ] All divisions guarded against zero
- [ ] Array types guarded before accessing properties
- [ ] All composite key components coalesced

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `value ?? 0` in sums | Track nulls separately |
| Unchecked division | Guard with `> 0` |
| Missing type guard | Add `Array.isArray()` check |
| NULL in keys | Coalesce all components |
