---
name: plan-task
description: Template for structured architecture planning and task breakdown
---

```jinja2
{# goal: What we're trying to achieve - single sentence #}
{# context: Background, client requirements, existing constraints #}
{# scope: What files/systems are affected #}
{# questions: Open questions to resolve before implementation (optional) #}

## Planning: {{goal|required}}

**Context:**
{{context|required}}

**Scope:**
{{scope|required|multiline}}

### Planning Checklist

1. **Understand current state** - Read relevant files, map dependencies
2. **Identify constraints** - What must NOT change? Backward compatibility?
3. **Design approach** - Propose 1-2 options with tradeoffs
4. **Break into tasks** - Ordered list with agent assignments and dependencies
5. **Define verification** - How do we know each task is done?

### Open Questions
{{questions|optional|multiline}}

### Output Expected

Produce a structured plan with:
- Ordered task list with agent assignments (implementer, test-runner, researcher)
- File-level change descriptions for each task
- Dependencies between tasks
- Risk assessment (what could go wrong)
- Verification strategy (test commands, expected results)
```
