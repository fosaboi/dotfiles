# Content Patterns

**Core:** Write clear, actionable, concise content.

---

## Imperative Voice

**Always use commands, never suggestions:**

```markdown
# ✅ DO
Check status
Run command
Fix error

# ❌ DON'T
You should check
Please run
We need to fix
```

---

## Code Blocks

**Always specify language:**

```markdown
```bash
npm run build
```

```python
def fetch():
    pass
```
```

**Keep focused:** One logical unit per block

---

## Formatting

### Lists
- **Numbered:** Sequential actions
- **Bullet:** Unordered items
- **Checklist:** Verification

```markdown
1. First action
2. Second action

- Option A
- Option B

- [ ] Check 1
- [ ] Check 2
```

### Tables

```markdown
| Column | Description |
|--------|-------------|
| Value | Meaning |
```

### Emphasis
- **Bold:** Important terms, warnings, code
- *Italic:* Variables, placeholders

```markdown
**WARNING:** Irreversible action
*Replace* VALUE with actual value
```

---

## Common Patterns

### Simple Instruction
```markdown
Check the build status:

```bash
npm run build
```
```

### Instruction with Verification
```markdown
Run the build:

```bash
npm run build
```

**Verify:**
```bash
ls dist/
```
```

### Instruction with Error Handling
```markdown
Deploy the service:

```bash
kubectl apply -f deployment.yaml
```

**If error:**
1. Check YAML syntax
2. Verify cluster connection
```

### Before/After
```markdown
**Before:**
```bash
manual step 1
manual step 2
```

**After:**
```bash
/skill-name
```
```

---

## Checklist

- [ ] Imperative voice used
- [ ] All commands in code blocks
- [ ] Language specified
- [ ] Examples provided
- [ ] No vague language
- [ ] Formatting consistent
