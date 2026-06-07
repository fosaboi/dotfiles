---
name: async-safety
description: >-
  Prevent race conditions, memory leaks, and stale state in async operations.
  Triggers on: "async", "race condition", "cleanup", "abort", "useEffect"
---

# Async Safety

**Core Principle:** Async operations can outlive their context. Always clean up.

## When to Use
- Any async operation (fetch, setTimeout, setInterval)
- React useEffect with async
- Long-running operations
- Do NOT use for synchronous code

---

## Step 1 — AbortController Pattern

**Cancel in-flight requests on unmount or re-run.**

```typescript
// ❌ WRONG - race condition on toggle/unmount
useEffect(() => {
  fetch('/api/data').then(r => r.json())
}, [deps])

// ✅ CORRECT - abort on cleanup
useEffect(() => {
  const ctrl = new AbortController()
  
  fetch('/api/data', { signal: ctrl.signal })
    .then(r => r.json())
    .catch(err => {
      if (err.name === 'AbortError') return // Expected, ignore
      setError(err.message)
    })
  
  return () => ctrl.abort() // Cleanup: cancel request
}, [deps])
```

**Scenario:** User toggles mode while fetch is in-flight → old fetch completes and overwrites new state.

---

## Step 2 — React useEffect Cleanup

**Return cleanup function to prevent leaks.**

```typescript
useEffect(() => {
  const subscription = source.subscribe(callback)
  const timer = setInterval(task, 1000)
  const timeout = setTimeout(task, 5000)
  
  return () => {
    subscription.unsubscribe()
    clearInterval(timer)
    clearTimeout(timeout)
  }
}, [deps])
```

**Why:** Without cleanup, operations continue after component unmounts.

---

## Step 3 — Avoid Import-Time Async

**Don't start async at module import.**

```python
# ❌ WRONG - runs at import time
schedule = ScheduleDefinition(
    input=SyncAllRequest(),  # Constructed once
)

# ✅ CORRECT - defer to runtime
schedule = ScheduleDefinition(
    input={},  # Resolved at runtime
)
```

**Why:** Import-time construction freezes defaults and can crash workers.

---

## Quick Checklist
- [ ] All fetches use AbortController
- [ ] useEffect returns cleanup function
- [ ] AbortError filtered in catch
- [ ] No async at module import
- [ ] Subscriptions/timers cleaned up

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| No AbortController | Add signal + cleanup |
| No cleanup function | Return cleanup from useEffect |
| Not filtering AbortError | Check `err.name === 'AbortError'` |
| Async at import | Defer to runtime |
