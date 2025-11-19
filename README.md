# Multi-Agent Research System

**5-Tier Adaptive Research Orchestration for Claude Code**

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/ahmedibrahim085/multi-agent-research/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Claude](https://img.shields.io/badge/claude-sonnet%204.5-purple.svg)](https://www.anthropic.com/)

An intelligent research infrastructure that automatically routes queries to optimal agent tiers based on complexity. Routes from simple lookups to comprehensive multi-dimensional analysis.

---

## Table of Contents

- [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Your First Research Query](#your-first-research-query)
- [Why This Approach?](#why-this-approach)
  - [vs. Direct Tools (WebSearch/WebFetch)](#vs-direct-tools-websearchwebfetch)
  - [vs. Sequential Research](#vs-sequential-research)
  - [vs. Manual Agent Selection](#vs-manual-agent-selection)
  - [vs. Single-Tier Orchestration](#vs-single-tier-orchestration)
  - [When NOT to Use](#when-not-to-use)
- [How It Works](#how-it-works)
- [5-Tier Routing System](#5-tier-routing-system)
- [Research Methodologies](#research-methodologies)
- [Project Architecture](#project-architecture)
- [Configuration](#configuration)
- [Use Cases & Examples](#use-cases--examples)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Inspiration & Credits](#inspiration--credits)
- [License](#license)

---

## Quick Start

### Prerequisites

- **Claude Code** installed ([documentation](https://code.claude.com/docs))
- **Git**

### Installation

1. **Clone the repository**:
```bash
git clone https://github.com/ahmedibrahim085/multi-agent-research.git
cd multi-agent-research
```

2. **Start Claude Code**:
```bash
claude
```

The UserPromptSubmit hook will automatically activate routing for all research queries.

### Your First Research Query

Try this example:
```
Research quantum computing security challenges
```

**Expected output**:
```
[ROUTING DIRECTIVE]
This is a 2-dimension research query. Use internet-light-orchestrator skill to coordinate parallel researchers.

Research Path: docs/research-sessions/DDMMYYYY_HHMMSS_*/
Tier: 3
Intent: information_gathering
Complexity: moderate
Dimensions: 2

---

# Research Complete: Quantum Computing Security Challenges

Comprehensive research completed with 2 parallel researchers.

## Key Findings
1. [Findings from security researcher]
2. [Findings from quantum researcher]

## Files Generated
**Research Notes**: docs/research-sessions/DDMMYYYY_HHMMSS_*/
- quantum-security-basics_DDMMYYYY-HHMMSS.md
- quantum-threats-analysis_DDMMYYYY-HHMMSS.md

**Final Report**: quantum-computing-security-challenges_DDMMYYYY-HHMMSS.md
```

---

## Why This Approach?

### The Core Innovation: 5-Tier Adaptive Routing

Traditional research systems require users to manually choose agents or use a single orchestration pattern for all queries. This project introduces **adaptive tier selection** that automatically matches query complexity to optimal research strategies.

### vs. Direct Tools (WebSearch/WebFetch)

**Direct approach**:
```
User: "Tell me about quantum computing"
→ Claude does 1-2 WebSearch calls
→ Returns summary from top results
→ Limited depth, single perspective
```

**5-Tier adaptive approach**:
```
User: "Research quantum computing"
→ Router analyzes query (intent, complexity, domain, dimensions)
→ Detects moderate complexity (2 subtopics)
→ Spawns Tier 3: internet-light-orchestrator skill
→ Orchestrator decomposes into subtopics (basics, applications)
→ Spawns 2 researcher agents in parallel
→ Each conducts focused, multi-source research
→ Report-writer synthesizes comprehensive findings
→ Cross-referenced, authoritative sources
```

**When direct tools are sufficient**: Single factual questions ("What is X?"), quick documentation lookups, specific URL fetches.

### vs. Sequential Research

**Sequential Approach** (traditional pattern):
- Research subtopics one-by-one
- Total time: N × (research time per subtopic)
- Example: 3 subtopics × 10 min each = **30 minutes**

**Parallel Orchestration** (Tier 3-5):
- Research all subtopics simultaneously (Claude Code supports up to 10 parallel tasks)
- Total time: max(research times) + synthesis time
- Example: max(10, 12, 8 min) + 3 min = **15 minutes**
- **~30-50% faster** for typical 2-4 subtopic research

**Additional benefits**:
- **Reliability**: If one researcher fails, others complete; orchestrator can retry
- **Isolation**: Independent researchers can't block each other
- **Scalability**: Performance scales with subtopic count

### vs. Manual Agent Selection

**Manual Selection**:
```
User: "I need research on machine learning algorithms"
→ User must know: which agents exist, which is appropriate
→ User types: "Use academic-researcher to research ML algorithms"
→ May choose suboptimal agent for task
```

**Automatic Routing** (this project):
```
User: "Research machine learning algorithms"
→ Router analyzes: academic domain + focused complexity
→ Automatically routes to: academic-researcher agent (Tier 2)
→ User gets optimal agent without needing domain knowledge
```

**Cost optimization example**:
```
Query: "I need comprehensive, thorough, in-depth research on what blockchain is"
Keywords suggest: comprehensive (Tier 3-4, expensive orchestration)
Actual intent: Simple definition lookup (Tier 1, cheap direct agent)
Decision: Routes to web-researcher (Tier 1)
→ Saves ~90% cost vs. spawning orchestrator
```

This **intent override** prevents keyword inflation waste.

### vs. Single-Tier Orchestration

**Single-Tier Systems** (like [Claude-Multi-Agent-Research-System-Skill](https://github.com/ahmedibrahim085/Claude-Multi-Agent-Research-System-Skill)):
- Use one orchestration pattern for all queries
- Always decompose → parallel research → synthesis
- Excellent workflow enforcement via `allowed-tools`
- But: Same overhead for simple queries as complex ones
- Cost: Always pays for orchestrator invocation

**5-Tier Adaptive System** (this project):
- **Tier 1**: Simple queries bypass orchestration entirely → Direct agent spawn
- **Tier 2**: Focused queries use specialist agents → No orchestration overhead
- **Tier 3**: Standard queries (2-3 dimensions) → Light orchestration (Haiku model)
- **Tier 4**: Complex queries (4+ dimensions) → Full orchestration (Sonnet model, RBMAS)
- **Tier 5**: Novel domains → Adaptive orchestration (Sonnet model, TODAS)

**Example**:
```
Simple query: "What is machine learning?"
→ Single-tier: Spawns orchestrator → decomposes → researchers → synthesis (expensive)
→ 5-tier: Directly spawns web-researcher (cheap, fast)
Result: 5-tier is ~12x cheaper for simple queries
```

**When to use each**:
- **Single-tier orchestration**: When you always need comprehensive, structured research with quality gates
- **5-tier adaptive routing**: When queries vary from simple to complex, and cost efficiency matters

Both approaches use architectural enforcement (`allowed-tools` constraints). The difference is **when** orchestration happens.

### When NOT to Use

This system is **overkill** for:

- ❌ Single factual questions ("What is the capital of France?")
- ❌ Quick lookups ("Latest version of Python?")
- ❌ Code-related tasks ("Debug this function", "Write a script")
- ❌ Simple decision evaluation ("Should I use React or Vue?")

**Use direct interaction** with Claude Code for these instead.

**Use this system when**:

- ✅ Multi-source research needed (2+ perspectives)
- ✅ Synthesis across domains required
- ✅ Comprehensive coverage important
- ✅ Academic rigor needed (citations, peer-reviewed sources)
- ✅ Parallel exploration beneficial (multiple subtopics)
- ✅ Query complexity varies (let router optimize tier selection)

---

## How It Works

### Phase 1: Query Analysis

**UserPromptSubmit Hook** (`internet-search-router.sh`) analyzes every query across 4 dimensions:

1. **Intent Classification** (5 types):
   - `information_gathering`: General searches, definitions
   - `analysis`: Deep investigation, synthesis
   - `verification`: Fact-checking, validation
   - `forecasting`: Trends, predictions
   - `synthesis`: Combining findings

2. **Complexity Assessment** (5 levels):
   - `simple`: Single-dimension, straightforward lookup
   - `focused`: Single-domain expertise required
   - `moderate`: 2-3 dimensions, parallel exploration needed
   - `comprehensive`: 4+ dimensions, full orchestration required
   - `novel`: Emerging domain, no established patterns

3. **Domain Identification**:
   - `web`, `academic`, `market`, `competitive`, `trends`, `multi`

4. **Dimension Counting**:
   - Counts explicit dimensions via "and", commas, semicolons
   - Examples: "Research blockchain" → 1, "Blockchain security and scalability" → 2

### Phase 2: Tier Selection & Directive Injection

Based on analysis, router selects optimal tier and injects directive into prompt:

```
[ROUTING DIRECTIVE]
This is a 2-dimension research query. Use internet-light-orchestrator skill to coordinate parallel researchers.

Research Path: docs/research-sessions/DDMMYYYY_HHMMSS_*/
Tier: 3
Intent: information_gathering
Complexity: moderate
Domain: web
Dimensions: 2
```

Main Claude receives this amended prompt and automatically invokes the specified skill/agent.

### Phase 3: Agent Orchestration

**Tier 1-2** (Direct Agent Spawn):
```
Main Claude → Spawns single specialist agent → Agent researches → Returns results
```

**Tier 3** (Light Parallel):
```
internet-light-orchestrator skill
    ↓
Decompose query into 2-3 subtopics
    ↓
Spawn parallel researchers (light-research-researcher agents)
    ↓
Each researcher: 3-7 WebSearch calls → Save notes
    ↓
light-research-report-writer synthesizes findings
```

**Tier 4** (Comprehensive RBMAS):
```
internet-deep-orchestrator skill
    ↓
7-Phase RBMAS methodology
    ↓
Phase 3 (RETRIEVE): Spawn 4+ specialist agents in parallel
    ├─→ web-researcher
    ├─→ academic-researcher
    ├─→ fact-checker
    └─→ synthesis-researcher
    ↓
Phases 4-7: Triangulate → Draft → Critique → Package
```

**Tier 5** (Novel Domain TODAS):
```
internet-research-orchestrator skill
    ↓
Adaptive methodology (1-7 subagents based on novelty)
    ↓
Dynamic resource allocation
    ↓
Multi-perspective synthesis
```

### Phase 4: Synthesis & Delivery

- **Tier 1-2**: Direct findings returned to user
- **Tier 3-5**: Orchestrator verifies research notes exist (quality gate), spawns synthesis agent, produces comprehensive report

---

## 5-Tier Routing System

**Design Philosophy**: Match research complexity to optimal agent/orchestrator tier, minimizing cost while maximizing quality.

| Tier | Name | Strategy | Agents | Parallel | Model | Cost/1M | Example Query |
|------|------|----------|--------|----------|-------|---------|---------------|
| **1** | Simple | Direct spawn | 1 | No | Haiku | $0.25 | "What is machine learning?" |
| **2** | Specialist | Domain expert | 1 | No | Sonnet | $3.00 | "Find academic papers on quantum computing" |
| **3** | Light Parallel | Orchestrated | 2-3 | Yes | Haiku | $0.25 | "Research REST vs GraphQL" |
| **4** | Comprehensive | RBMAS 7-phase | 4+ | Yes | Sonnet | $3.00 | "Analyze cybersecurity: encryption, network, vulnerabilities, compliance" |
| **5** | Novel | TODAS adaptive | 1-7 | Yes | Sonnet | $3.00 | "Investigate AI + blockchain convergence 2026" |

**Cost Optimization**:
- Tier 1 + 3 use **Haiku** ($0.25/1M) → 12x cheaper than Sonnet
- Tier 2, 4, 5 use **Sonnet** ($3.00/1M) → Quality-focused
- Intent override prevents keyword inflation waste
- Dimension counting automates tier selection

### 13 Specialized Agents

**Tier 1 (Simple)**:
- **web-researcher**: General web search, online information gathering
- **fact-checker**: Claim verification, source validation
- **citations-agent**: Citation formatting, reference management

**Tier 2 (Specialist)**:
- **academic-researcher**: Peer-reviewed papers, scholarly sources
- **search-specialist**: Advanced search techniques, Boolean queries
- **trend-analyst**: Future forecasting, weak signal detection
- **market-researcher**: Market sizing (TAM/SAM/SOM), segmentation
- **competitive-analyst**: Competitor profiling, SWOT analysis
- **synthesis-researcher**: Multi-source synthesis, pattern identification

**Tier 3 (Workers)**:
- **light-research-researcher**: Parallel research worker (Haiku model, 3-7 searches)
- **light-research-report-writer**: Synthesis writer (Haiku model)

**Orchestrators** (Skills):
- **internet-light-orchestrator** (Tier 3): 2-3 dimension parallel research
- **internet-deep-orchestrator** (Tier 4): 7-phase RBMAS methodology
- **internet-research-orchestrator** (Tier 5): Adaptive TODAS for novel domains

**Utility**:
- **research-subagent**: OODA loop research execution (general-purpose)

### Hook System

**UserPromptSubmit Hook**: Intercepts queries BEFORE Main Claude processes them
- 4D analysis: intent, complexity, domain, dimensions
- Tier selection (1-5)
- Routing directive injection
- Logs all routing decisions to `project_logs/router-log.jsonl`

**Monitoring Hooks**:
- **PreToolUse**: Logs tool call before execution
- **PostToolUse**: Logs tool call after execution, captures output
- **SubagentStop**: Logs agent termination

**Log Outputs**:
- `project_logs/router-log.jsonl`: Routing decisions (one per query)
- `project_logs/agent_start_log.jsonl`: Agent spawn events
- `project_logs/tool_calls.jsonl`: All tool invocations (JSONL format)
- `project_logs/transcript.txt`: Human-readable conversation log

---

## Research Methodologies

### Tier 3: Light Parallel (HAIKU)

**Use case**: Standard research with 2-3 distinct dimensions

**Workflow**:
```
internet-light-orchestrator skill
    ↓
1. Decompose query into 2-3 subtopics
2. Spawn light-research-researcher agents in parallel
3. Each researcher performs 3-7 web searches
4. Saves markdown notes to docs/research-sessions/{session_id}/
5. light-research-report-writer reads all notes
6. Synthesizes comprehensive final report
```

**Model**: Haiku (cost-optimized)
**Cost**: ~$0.001 per query (~12x cheaper than Sonnet)
**Speed**: ~15 minutes for 3 subtopics (vs. 30 min sequential)

**Example**:
```
Query: "Research REST vs GraphQL APIs"
→ Tier 3: 2 dimensions detected
→ Subtopics:
    1. REST API architecture, patterns, use cases
    2. GraphQL query language, schema, benefits
→ 2 parallel researchers spawn
→ Synthesis report: REST vs GraphQL comparison
```

### Tier 4: Comprehensive RBMAS (SONNET)

**Use case**: Multi-dimensional established domains (4+ dimensions)

**RBMAS Methodology** (7 phases):
1. **SCOPE**: Define research question, identify dimensions
2. **PLAN**: Allocate specialist agents to dimensions
3. **RETRIEVE**: Spawn agents in parallel, gather information
4. **TRIANGULATE**: Cross-verify findings, assess quality
5. **DRAFT**: Synthesize preliminary report
6. **CRITIQUE**: Quality review, gap detection
7. **PACKAGE**: Final comprehensive report

**Model**: Sonnet (quality-focused)
**Agents**: Coordinates 4+ specialist agents in parallel
**Speed**: ~20-30 minutes for 4 dimensions

**Example**:
```
Query: "Analyze cloud security across encryption, access control, compliance, monitoring"
→ Tier 4: 4 dimensions detected
→ RBMAS orchestration:
    Phase 1: SCOPE → 4 dimensions identified
    Phase 2: PLAN → Allocate:
        - web-researcher → encryption methods
        - academic-researcher → access control models
        - search-specialist → compliance frameworks
        - fact-checker → monitoring solutions
    Phase 3: RETRIEVE → 4 agents spawn in parallel
    Phase 4-7: Triangulate, draft, critique, package
→ Comprehensive report with cross-referenced findings
```

### Tier 5: Novel Domain TODAS (SONNET)

**Use case**: Unprecedented/emerging topics, post-training data

**TODAS Methodology** (Adaptive):
1. **Threshold** analysis: Determine if truly novel
2. **Orchestrate**: Deploy 1-7 adaptive specialists
3. **Depth-first** or **breadth-first** approach selection
4. **Allocate**: Dynamic resource allocation based on findings
5. **Synthesize**: Multi-perspective synthesis with uncertainty acknowledgment

**Triggers**: Keywords like "novel", "emerging", "2025", "2026", "unprecedented", "new technology"
**Model**: Sonnet (requires sophisticated reasoning)
**Adaptive**: Agents 1-7 based on domain complexity

**Example**:
```
Query: "Investigate quantum-resistant cryptography for blockchain networks in 2026"
→ Tier 5: Novel domain detected (post-training, emerging)
→ TODAS adaptive orchestration:
    1. Threshold: Novel (quantum + blockchain + future)
    2. Orchestrate: 5 specialists allocated
        - academic-researcher → quantum cryptography papers
        - trend-analyst → quantum computing timeline forecast
        - web-researcher → current blockchain crypto standards
        - synthesis-researcher → integration feasibility
        - fact-checker → verify quantum threat timeline
    3. Depth-first: Deep dive on quantum algorithms
    4. Allocate: Additional researcher for post-quantum standards
    5. Synthesize: Report with uncertainty acknowledgment
→ Comprehensive novel domain analysis
```

---

## Project Architecture

The system consists of three main layers: **Routing Layer** (hooks), **Orchestration Layer** (skills), and **Execution Layer** (agents).

#### Complete File Reference

**System Role Legend**:
- 🎯 **Critical** - System won't work without this
- 🔧 **Core** - Essential for main functionality
- 📊 **Monitoring** - Observability and debugging
- 📚 **Documentation** - User guidance
- 🛡️ **Quality** - Validation and standards

| File/Directory | Type | Role | Used For | System Impact |
|----------------|------|------|----------|---------------|
| **Core Documentation** | | | | |
| `README.md` | Documentation | 📚 | Project overview, setup, usage guide | User onboarding - explains how to use the system |
| `LICENSE` | Legal | 📚 | MIT License | Legal protection for users and contributors |
| `CHANGELOG.md` | Documentation | 📚 | Version history and release notes | Track what changed between versions |
| `CONTRIBUTING.md` | Documentation | 📚 | Contribution guidelines and workflow | Enable community contributions |
| `CODE_OF_CONDUCT.md` | Documentation | 📚 | Community standards | Maintain healthy community interactions |
| `SECURITY.md` | Documentation | 📚 | Security policy and vulnerability reporting | Handle security issues responsibly |
| **Routing Layer (Hooks)** | | | | |
| `.claude/hooks/user-prompt-submit/internet-search-router.sh` | Shell Script | 🎯 | Query analyzer and automatic tier selector | **CRITICAL**: Without this, no automatic routing happens - users must manually select agents |
| `.claude/hooks/monitoring/pre_tool_use.sh` | Shell Script | 📊 | Pre-execution logger | Records what tool is about to run (debugging, audit trail) |
| `.claude/hooks/monitoring/post_tool_use.sh` | Shell Script | 📊 | Post-execution logger | Records tool results and outputs (debugging, performance analysis) |
| `.claude/hooks/monitoring/subagent_stop.sh` | Shell Script | 📊 | Agent termination tracker | Logs when agents finish (track research workflow completion) |
| `.claude/settings.json` | JSON Config | 🎯 | Hook registration with Claude Code | **CRITICAL**: Tells Claude Code which hooks to run when - without this, hooks don't activate |
| `.claude/config.sh` | Shell Script | 🔧 | Centralized path configuration | Ensures hooks know where to write logs consistently |
| **Orchestration Layer (Skills)** | | | | |
| `.claude/skills/internet-light-orchestrator/SKILL.md` | Skill Definition | 🔧 | Tier 3 orchestrator for 2-3 dimensions | Spawns parallel researchers + report writer (cost-efficient Haiku model) |
| `.claude/skills/internet-deep-orchestrator/SKILL.md` | Skill Definition | 🔧 | Tier 4 orchestrator for 4+ dimensions | Runs 7-phase RBMAS methodology, coordinates multiple specialist agents |
| `.claude/skills/internet-research-orchestrator/SKILL.md` | Skill Definition | 🔧 | Tier 5 orchestrator for novel domains | Adaptive TODAS methodology, handles unprecedented topics (1-7 agents) |
| **Execution Layer (Agents)** | | | | |
| `.claude/agents/web-researcher.md` | Agent Definition | 🔧 | Tier 1 - Simple queries | Handles basic lookups, general web information (most common use case) |
| `.claude/agents/fact-checker.md` | Agent Definition | 🔧 | Tier 1 - Verification | Validates claims, checks source credibility (quality assurance) |
| `.claude/agents/citations-agent.md` | Agent Definition | 🔧 | Tier 1 - Citation management | Formats citations, manages references (academic rigor) |
| `.claude/agents/academic-researcher.md` | Agent Definition | 🔧 | Tier 2 - Academic specialist | Searches peer-reviewed papers, scholarly databases (research depth) |
| `.claude/agents/search-specialist.md` | Agent Definition | 🔧 | Tier 2 - Advanced search | Complex Boolean queries, search optimization (precision) |
| `.claude/agents/trend-analyst.md` | Agent Definition | 🔧 | Tier 2 - Future forecasting | Analyzes trends, detects weak signals (forward-looking insights) |
| `.claude/agents/market-researcher.md` | Agent Definition | 🔧 | Tier 2 - Market analysis | Sizes markets (TAM/SAM/SOM), segments audiences (business intelligence) |
| `.claude/agents/competitive-analyst.md` | Agent Definition | 🔧 | Tier 2 - Competitive intelligence | Profiles competitors, SWOT analysis (strategic positioning) |
| `.claude/agents/synthesis-researcher.md` | Agent Definition | 🔧 | Tier 2 - Multi-source synthesis | Combines findings from multiple sources (holistic analysis) |
| `.claude/agents/research-subagent.md` | Agent Definition | 🔧 | General-purpose worker | OODA loop research execution (flexible research tasks) |
| `.claude/agents/light-research-researcher.md` | Agent Definition | 🔧 | Tier 3 parallel worker | Conducts focused research (3-7 searches), saves notes (parallelization) |
| `.claude/agents/light-research-report-writer.md` | Agent Definition | 🔧 | Tier 3 synthesis worker | Reads all research notes, creates final report (synthesis phase) |
| `.claude/agents/agent_registry.json` | JSON Registry | 🔧 | Agent metadata catalog | Lists all 13 agents with tier, domain, description (agent discovery) |
| **Configuration & Metadata** | | | | |
| `.claude/CLAUDE.md` | Instructions | 🎯 | Main system instructions (28 KB) | **CRITICAL**: Tells Claude Code HOW to use agents, when to route, what each tier does - the "brain" of the system |
| `.claude/prompts/agent-startup-logging.md` | Prompt Template | 📊 | Agent startup logging protocol | Template ensuring agents log their initialization consistently |
| `.mcp.json` | MCP Config | 🔧 | Optional MCP server configuration | Enables memory (knowledge graph) and sequential-thinking (structured reasoning) |
| `.gitignore` | Git Config | 🔧 | Git ignore rules | Prevents committing logs, sensitive data, temporary files (repo cleanliness) |
| **GitHub Infrastructure** | | | | |
| `.github/ISSUE_TEMPLATE/bug_report.yml` | YAML Template | 🛡️ | Structured bug reports | Collects tier, version, environment info (better bug tracking) |
| `.github/ISSUE_TEMPLATE/feature_request.yml` | YAML Template | 🛡️ | Structured feature requests | Categorizes requests by type (agent, skill, routing, MCP, etc.) |
| `.github/ISSUE_TEMPLATE/config.yml` | YAML Config | 🛡️ | Issue template router | Directs users to discussions for questions, security advisory for vulnerabilities |
| `.github/pull_request_template.md` | Markdown Template | 🛡️ | PR template with checklist | Ensures PRs include description, testing, agent registry updates |
| `.github/workflows/validate.yml` | GitHub Actions | 🛡️ | CI validation on push/PR | Auto-checks: required files exist, JSON valid, no secrets leaked |
| `.github/workflows/markdown-link-check-config.json` | JSON Config | 🛡️ | Link checker settings | Validates markdown links aren't broken (documentation quality) |
| **Runtime Outputs (gitignored)** | | | | |
| `project_logs/router-log.jsonl` | JSONL Log | 📊 | Router decision log | **Debugging**: See why router chose specific tier (transparency, troubleshooting) |
| `project_logs/agent_start_log.jsonl` | JSONL Log | 📊 | Agent spawn tracking | **Debugging**: Track which agents were launched when (workflow analysis) |
| `project_logs/tool_calls.jsonl` | JSONL Log | 📊 | Tool invocation log | **Debugging**: Every WebSearch/WebFetch call logged (performance, cost tracking) |
| `project_logs/transcript.txt` | Text Log | 📊 | Human-readable conversation | **Debugging**: Full conversation history (reproduce issues) |
| `project_logs/agent_mapping.jsonl` | JSONL Log | 📊 | Agent relationship mapping | **Debugging**: Which orchestrator spawned which agents (trace execution flow) |
| `docs/research-sessions/{session_id}/` | Markdown Files | 📊 | Research outputs | **Output**: Research notes + final reports saved here (user deliverables) |
| **Documentation (Project Specific)** | | | | |
| `docs/PUBLICATION_READINESS_REPORT.md` | Documentation | 📚 | v1.0.0 publication analysis | Historical: Analysis from v1.0.0 publication preparation |
| `docs/github-publication-analysis.md` | Documentation | 📚 | Open-source best practices | Historical: Research on GitHub publication standards (18,000+ words) |

### How The System Works (File Flow)

**Query Flow**:
```
1. User query → .claude/hooks/user-prompt-submit/internet-search-router.sh
   ↓ (Router analyzes query, selects tier)
2. Router injects directive → Main Claude receives amended prompt
   ↓ (Claude reads directive)
3. Main Claude invokes skill/agent based on directive:
   - Tier 1-2: Spawns agent directly from .claude/agents/
   - Tier 3-5: Invokes skill from .claude/skills/
   ↓
4. Orchestrators (Tier 3-5) spawn worker agents from .claude/agents/
   ↓
5. Agents use WebSearch/WebFetch tools → Research
   ↓
6. Results → User
```

**Logging Flow**:
```
1. PreToolUse hook → Logs to project_logs/ before tool execution
2. Tool executes
3. PostToolUse hook → Logs to project_logs/ after tool execution
4. SubagentStop hook → Logs when agent terminates
```

**Configuration Sources**:
- `.claude/settings.json` - Hook registration (which hooks run when)
- `.claude/CLAUDE.md` - System instructions (how to use agents/skills)
- `.claude/agents/agent_registry.json` - Agent metadata (which agents exist)
- `.mcp.json` - Optional MCP servers (memory, sequential-thinking)

---

## Configuration

### Installation

**No additional installation required.** The system works out-of-the-box with Claude Code's built-in `WebSearch` and `WebFetch` tools.

**Setup Steps**:
1. Clone the repository (see [Quick Start](#quick-start))
2. Start Claude Code in the project directory
3. The UserPromptSubmit hook will automatically activate

### Optional Enhancements

While not required, you can optionally install MCP servers for enhanced capabilities:

**Sequential Thinking MCP** (FREE - structured reasoning):
```bash
claude mcp add sequential-thinking -s local -- npx -y @modelcontextprotocol/server-sequential-thinking
```

**Memory MCP** (knowledge graph persistence):
Already configured in `.mcp.json`. No additional installation needed.

### Environment

No environment variables required for basic operation.

---

## Use Cases & Examples

### Information Gathering
```
"What is machine learning?"                 → Tier 1 (web-researcher)
"Find academic papers on quantum computing" → Tier 2 (academic-researcher)
"Verify this claim about climate data"     → Tier 2 (fact-checker)
```

### Market Intelligence
```
"Market size for electric vehicles 2025"   → Tier 2 (market-researcher)
"Compare Zoom vs Teams vs Google Meet"     → Tier 2 (competitive-analyst)
"Forecast AI assistant adoption 2025-2027" → Tier 2 (trend-analyst)
```

### Comprehensive Analysis
```
"Research push notifications: FCM vs APNs" → Tier 3 (2 dimensions, light parallel)
"Analyze cloud security: encryption, access control, compliance, monitoring"
                                           → Tier 4 (4 dimensions, RBMAS)
"Investigate AI + blockchain convergence in decentralized systems 2026"
                                           → Tier 5 (novel domain, TODAS)
```

### Synthesis from Multiple Sources
```
"Research multimodal AI developments in 2025"
→ Tier 4 orchestration:
    ├─ web-researcher (current news/blogs)
    ├─ academic-researcher (recent papers)
    ├─ trend-analyst (future forecasts)
    └─ synthesis-researcher (combine findings)
```

---

## Best Practices

### 1. Clear Research Questions

```
❌ "Tell me about AI"
✅ "Research the performance differences between GPT-4 and Claude Sonnet 4 on coding tasks, with benchmarks from 2024-2025"
```

### 2. Let the Router Decide Depth

The router is smart - it analyzes intent vs. keywords:
```
"Quick search for..."          → Likely Tier 1 (intent override)
"Comprehensive research on..." → Suggests Tier 3-4 if multi-dimensional
"Find academic papers on..."   → Tier 2 (academic-researcher)
```

### 3. Verify Critical Information

For important decisions, request verification:
```
"Research X and verify all statistical claims"
→ Orchestrator will include fact-checker in workflow
```

### 4. Manual Override When Needed

If automatic routing doesn't match your needs:
```
"Use the academic-researcher agent to..."
"Ask the fact-checker to verify..."
"Have the trend-analyst forecast..."
```

### 5. Check Router Decisions

For transparency:
```bash
cat project_logs/router-log.jsonl | tail -1 | jq '.'
```

See which tier was selected and why.

---

## Troubleshooting

### Agent Not Invoking Automatically

**Symptoms**: Query doesn't trigger automatic routing

**Check**:
```bash
# Verify hook is registered
cat .claude/settings.json | jq '.hooks.UserPromptSubmit'

# Check hook permissions
ls -l .claude/hooks/user-prompt-submit/internet-search-router.sh
# Should show: -rwxr-xr-x (executable)
```

**Fix**:
```bash
# Make hook executable
chmod +x .claude/hooks/user-prompt-submit/internet-search-router.sh

# Restart Claude Code
```

**Manual invocation** (temporary workaround):
```
"Use the web-researcher agent to [your query]"
```

### Poor Research Results

**Try**:
1. **More specific instructions**
2. **Manually invoke appropriate specialist**: "Use academic-researcher to find papers on..."
3. **Request higher tier**: "Comprehensive research on X across Y, Z, and W dimensions" → Forces Tier 4

### Router Log Not Created

**Check**:
```bash
# Verify directory exists
ls -ld project_logs/

# Create if missing
mkdir -p project_logs
```

### Agent Files Not Found

**Check**:
```bash
ls -1 .claude/agents/*.md | wc -l
# Should output: 12 (agent files)

cat .claude/agents/agent_registry.json | jq '.agents | length'
# Should output: 13
```

**Fix**: Re-clone repository or verify all agent files are present.

---

## Inspiration & Credits

This project builds on proven multi-agent research patterns, adapted for Claude Code's 5-tier adaptive routing architecture.

### Primary Inspiration

- **[claude-agent-sdk-demos/research-agent](https://github.com/anthropics/claude-agent-sdk-demos/tree/main/research-agent)** by Anthropic PBC
  - Multi-agent research orchestration concept
  - Decomposition → Research → Synthesis workflow
  - Session logging patterns
  - License: Apache-2.0

### Workflow Patterns

- **[Claude-Multi-Agent-Research-System-Skill](https://github.com/ahmedibrahim085/Claude-Multi-Agent-Research-System-Skill)** by Ahmed Maged
  - Architectural enforcement via `allowed-tools` constraint
  - Quality gates for phase validation
  - Parallel execution patterns
  - Dual-format logging (JSONL)
  - License: Apache-2.0

### Additional Influences

- **Anthropic Model Context Protocol (MCP)** - Standard for connecting AI to data sources
- **Claude Code Hooks** - Event-driven automation for workflow enforcement
- **Sequential Thinking MCP** - Structured reasoning patterns

All referenced projects are Apache-2.0 or MIT licensed and used in compliance with their terms.

---

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

Copyright 2025 Ahmed Maged

---

**⭐ Star this repo** if you find it useful!

**Version**: 1.0.0
**Last Updated**: November 19, 2025
**Status**: Production-ready
