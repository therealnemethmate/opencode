---
name: explore-codebase
description: Template for delegating codebase exploration to the explorer agent
---

```jinja2
{# goal: What information are we looking for #}
{# scope: Directory/file patterns to focus on #}
{# questions: Specific questions to answer #}

**Goal:** {{goal|required}}

**Scope:**
{{scope|required|multiline}}

**Questions to Answer:**
{{questions|required|multiline}}

**Output Format:**
- File paths with line numbers
- Relevant code snippets (concise)
- Pattern observations
- Suggested follow-up searches if needed
```
