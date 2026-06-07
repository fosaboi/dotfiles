---
name: fetching
description: >-
  Safe data fetching patterns for HTTP and API requests.
  Always validate, always handle errors, always allow cancellation.
  Triggers on: "fetch", "HTTP", "API", "request", "axios"
---

# Fetching

**Core Principle:** External APIs are unreliable. Validate, handle errors, allow cancellation.

## When to Use
- Fetching data from REST APIs
- Calling external services
- Any HTTP request
- Do NOT use for local file access

---

## Step 1 — Create a Safe Fetch Helper

**Centralize error checking and cancellation.**

```typescript
// ✅ CORRECT - reusable helper
async function fetchJson<T>(url: string, signal?: AbortSignal): Promise<T> {
  const r = await fetch(url, { signal })
  if (!r.ok) throw new Error(`${url} returned ${r.status} ${r.statusText}`)
  return r.json() as Promise<T>
}
```

**Why:** `fetch()` doesn't throw on HTTP 4xx/5xx, only on network errors.

---

## Step 2 — Use the Helper Everywhere

**Never use raw fetch.**

```typescript
// ❌ WRONG - no error checking
fetch('/api/data').then(r => r.json())

// ✅ CORRECT - use helper
fetchJson<Data>('/api/data', ctrl.signal)
```

---

## Step 3 — Always Pass AbortSignal

**Enable cancellation.**

```typescript
useEffect(() => {
  const ctrl = new AbortController()
  
  Promise.all([
    fetchJson('/api/a', ctrl.signal),
    fetchJson('/api/b', ctrl.signal),
  ])
    .then(([a, b]) => setData({ a, b }))
    .catch(err => {
      if (err.name === 'AbortError') return
      setError(err.message)
    })
  
  return () => ctrl.abort()
}, [deps])
```

---

## Step 4 — Handle Parallel Requests

**Use Promise.all for multiple requests.**

```typescript
Promise.all([
  fetchJson<User>('/api/user'),
  fetchJson<Posts>('/api/posts'),
])
  .then(([user, posts]) => setState({ user, posts }))
  .catch(handleError)
```

---

## Quick Checklist
- [ ] All fetches use safe helper
- [ ] HTTP status checked (r.ok)
- [ ] AbortSignal passed
- [ ] AbortError filtered in catch
- [ ] Parallel requests use Promise.all

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Raw fetch() | Use fetchJson helper |
| No status check | Add `if (!r.ok) throw` |
| No cancellation | Pass AbortSignal |
| Not filtering AbortError | Check err.name |
