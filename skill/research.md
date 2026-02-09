---
name: research-task
description: Template for delegating external documentation research to the researcher agent
---

```jinja2
{# question: Specific research question to answer #}
{# context: Why we need this information - project context #}
{# sources: Preferred sources or libraries to check (optional) #}
{# version: Version constraints to be aware of (optional) #}

**Question:** {{question|required}}

**Context:** {{context|required}}

**Preferred Sources:**
{{sources|optional|multiline}}

**Version Constraints:**
{{version|optional}}

**Required in Response:**
1. Direct answer to the question
2. Source URLs with version numbers
3. Relevant code examples from documentation
4. Any caveats or version-specific gotchas
```
