---
name: error-handling
description: >-
  Handle failures explicitly and observably.
  Distinguish error states from empty states. Surface all failures.
  Triggers on: "error", "exception", "catch", "status check", "http error"
---

# Error Handling

**Core Principle:** Users and operators need to know *what* failed and *why*. Never silently swallow errors.

## When to Use
- Making HTTP requests
- Processing data from external sources
- Any operation that can fail
- Do NOT use for expected control flow

---

## Step 1 — HTTP Status Checks

**`fetch()` does NOT throw on HTTP errors (4xx, 5xx).**

```typescript
// ❌ WRONG - misses HTTP errors
fetch(url).then(r => r.json())

// ✅ CORRECT - always check r.ok
async function fetchJson<T>(url: string, signal?: AbortSignal): Promise<T> {
  const r = await fetch(url, { signal })
  if (!r.ok) throw new Error(`${url} returned ${r.status}`)
  return r.json() as Promise<T>
}
```

**Why:** `fetch()` only throws on network failures, not HTTP errors.

---

## Step 2 — State Differentiation

**Error ≠ Empty. Distinguish all states.**

```typescript
// ❌ WRONG - conflates error and empty
if (!data) return <p>No data available</p>

// ✅ CORRECT - separate states
const [error, setError] = useState<string | null>(null)
const [loading, setLoading] = useState(true)
const [data, setData] = useState<T | null>(null)

// In render:
if (error) return <Error message={error} />
if (loading) return <Spinner />
if (!data) return <EmptyState />
return <Content data={data} />
```

**States:**
- `error` = fetch/take failed
- `loading` = in progress
- `null` data = empty result (valid)

---

## Step 3 — Surface Non-Fatal Errors

**Non-fatal ≠ invisible.**

```python
# ❌ WRONG - silent failure
try:
    take_snapshot()
except Exception as e:
    logger.warning(f"Failed: {e}")

# ✅ CORRECT - surface in error collection
try:
    take_snapshot()
except Exception as e:
    all_errors.append(f"snapshot (non-fatal): {e}")
    logger.warning(f"Failed: {e}")
```

**Why:** Silent failures are undebuggable in production.

---

## Step 4 — Defensive Deserialization

**Valid JSON ≠ valid shape.**

```typescript
// ❌ WRONG - crashes on unexpected shape
const length = historyData.points.length

// ✅ CORRECT - guard at source
const safeHistory = history && Array.isArray(history.points) ? history : null
```

---

## Quick Checklist
- [ ] HTTP status checked on all requests
- [ ] Error/loading/empty states separated
- [ ] Non-fatal errors surfaced (not swallowed)
- [ ] Response shapes validated before use

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| No HTTP status check | Add `if (!r.ok) throw` |
| Conflating error/empty | Add separate error state |
| Silent catch | Append to error collection |
| Shape not guarded | Validate before accessing |
