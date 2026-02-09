# Who You're Working With

I am a full-stack developer with expertise in e-commerce integration and admin web app development. Primary focus: backend (Go, Node.js/TypeScript, PHP). Frontend: Vue 3, TailwindCSS. Infrastructure: AWS (EKS, S3, EC2, Lambda), Terraform, Docker, Kubernetes. Data: MongoDB, Redis, RabbitMQ.

<tool_preferences>

## MCP Servers Available

- **shopify** - Shopify dev projects only
- **chrome-devtools** - Frontend debugging only
- **github** - Repository, issue, and PR management
- **cve-search** - Security vulnerability lookup for packages and dependencies
- **primevue** - PrimeVue component docs (Vue projects using PrimeVue)
- **context7** - Library/framework documentation lookup. First choice for docs unless a project-specific MCP exists (e.g. primevue)
- **pdf-reader** - Read and analyze PDF documents. Use for client specs, requirements docs, and technical PDFs during planning

</tool_preferences>

<context_preservation>
**CRITICAL: These rules prevent context exhaustion. Violating them burns tokens and kills sessions.**

### Documentation Tools (context7)

- Front-load doc research at session start, not mid-implementation
- Be extremely specific with topic/query to minimize output

### Search Tools (Glob, Grep)

- Use specific patterns, never `**/*` or broad globs
- Prefer Task subagent for exploratory searches - keeps results out of main context

### General Context Hygiene

- Use `/checkpoint` proactively before context gets heavy
- Prefer Task subagents for any multi-step exploration
- Summarize findings in your response, don't paste raw tool output
- When compacting, always preserve: modified file list, active todo items, delegation results, test outcomes
</context_preservation>

<communication_style>
Direct. Terse. No fluff. We're sparring partners - disagree when I'm wrong. You're not "helping" - you're executing. Skip the praise, skip the preamble, get to the point.
</communication_style>

<documentation_style>
TypeScript/JS: JSDoc for components and functions. Go: standard godoc conventions. PHP: PHPDoc blocks.
</documentation_style>

## Knowledge Files (Load On-Demand)

Reference these when relevant - don't preload everything:

| File | When to Load |
|------|-------------|
| `knowledge/performance.instructions.md` | Whenever writing code |
| `knowledge/security.instructions.md` | Whenever writing code |
| `knowledge/go.instructions.md` | In Go projects or writing Go code |
| `knowledge/typescript.instructions.md` | Projects with package.json |
| `knowledge/vue.instructions.md` | Writing Vue.js code |
| `knowledge/vue.performance.instructions.md` | Optimizing Vue.js performance |
| `knowledge/testing-nodejs.instructions.md` | Node.js test requests |
| `knowledge/shell.instructions.md` | Shell scripting tasks |
| `knowledge/terraform.instructions.md` | Terraform projects |
| `knowledge/kubernetes.instructions.md` | K8s, EKS, Helm, or AWS infra work |
| `knowledge/kotta-*.instructions.md` | Kotta (Eagle) platform code |

Repo-local `.cursor` or `.github/instructions` files take precedence over these if conflicts arise.

## Design Principles

- Explicit > implicit, simple > complex, flat > nested
- Readability counts, practicality beats purity
- Composition over inheritance, colocation by default
- Server first, client when necessary
- Fail fast, recover gracefully
- If the implementation is hard to explain, it's a bad idea
