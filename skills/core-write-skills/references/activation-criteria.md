# Activation Criteria

**Core:** When should this skill be used?

---

## Trigger Phrases

**Format:** Natural language users say

```markdown
Triggers on: "deploy", "release", "push to production"
```

**Rules:**
- Cover common phrases
- Avoid false positives
- Be specific but not rigid

---

## Argument Hint

**Required if skill needs parameters:**

```yaml
argument-hint: "[service-name] | e.g., dashboard"
```

**Agent receives:** `$ARGUMENTS`

---

## Do NOT Use For

**Equally important:** Define exclusions

```markdown
Do NOT use for: debugging, local development
```

**Why:** Prevents agent confusion, directs to right skill

---

## Checklist

- [ ] Trigger phrases cover common usage
- [ ] Argument hint if parameters needed
- [ ] Exclusions clearly defined
- [ ] No overlap with other skills
- [ ] Tested: does it activate correctly?
