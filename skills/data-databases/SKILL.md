---
name: databases
description: >-
  Efficient and safe database query patterns.
  Push filters to DB, avoid full table loads, guard against NULL.
  Triggers on: "SQL", "query", "database", "filter", "table"
---

# Databases

**Core Principle:** Databases are for filtering. Application memory is not.

## When to Use
- Querying databases
- Loading data from tables
- Filtering datasets
- Do NOT use for in-memory collections

---

## Step 1 — Push Filters to Database

**Filter at query time, not in Python.**

```python
# ❌ WRONG - loads entire table, then filters
rows = GoldSnpCapacity.all()
filtered = [r for r in rows if r.region == region]

# ✅ CORRECT - filter at DB level
rows = GoldSnpCapacity.all().where(
    GoldSnpCapacity.region == region,
    GoldSnpCapacity.date >= start_date
)
```

**Why:** Tables grow unbounded. In-memory filtering doesn't scale.

---

## Step 2 — Add Limits with TODO

**Prevent accidental full-table loads.**

```python
# ✅ CORRECT - add limit with TODO for future
rows = GoldSnpCapacity.all().limit(1000)  # TODO: push filters to DB
```

---

## Step 3 — Guard Composite Keys

**Coalesce all nullable components.**

```sql
-- ❌ WRONG - NULL key if any component NULL
unique_key = "quarter || '-' || coalesce(region, 'Unknown')"

-- ✅ CORRECT - coalesce ALL
unique_key = "coalesce(quarter, 'Unknown') || '-' || coalesce(region, 'Unknown')"
```

**Why:** NULL in any part creates NULL composite key → infinite duplicate inserts.

---

## Step 4 — SCD2 Immutability

**Snapshot rows are write-once.**

```sql
-- ✅ CORRECT - only update dbt_valid_to
INSERT INTO table (...) VALUES (...)
ON CONFLICT (id) DO UPDATE 
  SET dbt_valid_to = EXCLUDED.dbt_valid_to
  WHERE table.dbt_valid_to IS DISTINCT FROM EXCLUDED.dbt_valid_to
```

**Principle:** Only `dbt_valid_to` (end timestamp) should change. Business metrics are immutable.

---

## Quick Checklist
- [ ] Filters pushed to DB (not in-memory)
- [ ] Limit added for unbounded queries
- [ ] All composite key components coalesced
- [ ] SCD2 rows follow write-once pattern

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `.all()` with in-memory filter | Push filter to query |
| No limit on unbounded table | Add `.limit()` + TODO |
| NULL in composite key | Coalesce all components |
| Updating SCD2 business cols | Only update `dbt_valid_to` |
