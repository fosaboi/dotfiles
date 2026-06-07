# Examples and Testing

**Core:** Examples show how to use the skill. Testing validates it works.

---

## Example Types

### Minimal Example
Show simplest use case.

```markdown
**Example:** Deploy a service
```bash
/deploy dashboard
```
```

### Usage Examples
Show different ways to use.

```markdown
**Deploy to staging:**
```bash
/deploy dashboard --env staging
```

**Deploy to production:**
```bash
/deploy dashboard --env production
```
```

### Before/After Example
Show value of using skill.

```markdown
**Before:**
```bash
step1 && step2 && step3
```

**After:**
```bash
/skill-name
```
```

---

## Example Rules

1. **Every step needs an example**
2. **Examples must be executable**
3. **Examples must be simple** (minimal working)
4. **Start simple, add complexity**

---

## Testing

### Manual Test
1. Read the skill
2. Follow workflow
3. Execute commands
4. Verify results

### Validation Questions
- Can I understand what to do?
- Are commands copy-pasteable?
- Do commands work?
- Are prerequisites stated?

### Agent Simulation
Give skill to another person. Can they complete the task using only the skill?

---

## Test Cases

### Happy Path
**Input:** `/deploy dashboard`
**Expected:** Success with no errors

### Edge Case
**Input:** `/deploy` (no args)
**Expected:** Error with usage instructions

### Error Case
**Input:** `/deploy invalid-service`
**Expected:** Helpful error message

---

## Checklist

- [ ] Examples for all major use cases
- [ ] Examples are executable
- [ ] Examples are simple
- [ ] Tested with real users
- [ ] All edge cases covered
