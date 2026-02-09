---
name: implement-task
description: Template for delegating code implementation to the implementer agent
---

```jinja2
{# task: Single sentence describing what to implement #}
{# context: Why this change is needed - helps implementer understand intent #}
{# files: Files to modify/create with paths and what changes in each #}
{# spec: Step-by-step implementation instructions - be explicit #}
{# knowledge: Knowledge files to reference (optional) #}
{# constraints: Additional constraints beyond the defaults (optional) #}

> [!IMPORTANT]
> When creating your todolist, NEVER add summary todos. The system automatically prompts you to report when todos are complete. Focus todos on actionable implementation steps.

**Task:** {{task|required}}

**Context:** {{context|required}}

**Files to modify:**
{{files|required|multiline}}

**Implementation Spec:**
{{spec|required|multiline}}

**Knowledge References:**
{{knowledge|optional}}

**Constraints:**
- Do NOT modify files not listed above
- Do NOT add anything not in the spec
- Do NOT run tests or builds
{{constraints|optional|multiline}}
```
