# Multi-Agent Research System - Claude Code Instructions

## Core Directive: ALWAYS Use Agents Proactively

**CRITICAL**: This project has 13 specialized research agents. You MUST use them actively, not just when asked. Think "Which agent should handle this?" before every task.

## Core Directive: ALWAYS Use Internet-Search Skill

**FOR ANY RESEARCH/SEARCH/ANALYSIS QUERY → USE INTERNET-SEARCH SKILL**

---

## 🚨 CRITICAL: Routing Directive Automation

**When you receive a `[ROUTING DIRECTIVE]` from the UserPromptSubmit hook, you MUST automatically execute it immediately. Do NOT ask permission, do NOT explain first - just invoke the specified skill/agent and let it handle the query.**

### Automation Rules (MANDATORY)

**IF you receive a message containing `[ROUTING DIRECTIVE]`**:

1. **Extract the directive** from the message
2. **Parse the instruction**:
   - IF contains `"Use [skill-name] skill"` → Invoke Skill tool with that skill name
   - IF contains `"Use [agent-name] agent directly"` → Invoke Task tool with that agent type
3. **Execute immediately** - NO asking, NO explaining beforehand
4. **Pass the original user query** to the skill/agent

### Pattern Matching Examples

**Tier 1 Directive** (Simple):
```
[ROUTING DIRECTIVE]
This is a simple lookup. Use web-researcher agent directly.
```
→ **Action**: `Task(subagent_type: "web-researcher", prompt: "[original user query]")`

**Tier 3 Directive** (Moderate):
```
[ROUTING DIRECTIVE]
Use internet-light-orchestrator skill. It is a tier 3 skill to coordinate parallel researchers, and report-writers.
```
→ **Action**: `Skill(skill: "internet-light-orchestrator")`

**Tier 4 Directive** (Comprehensive):
```
[ROUTING DIRECTIVE]
This is a comprehensive multi-dimensional query. Use tier-4-deep-research skill for 7-phase RBMAS research.
```
→ **Action**: `Skill(skill: "tier-4-deep-research")`

### What You MUST Do

✅ **ALWAYS**:
- Invoke the skill/agent immediately upon receiving directive
- Let the skill/agent handle the entire user query
- Only speak after the skill/agent returns results
- Synthesize and present the results to user

❌ **NEVER**:
- Ask "Shall I proceed with research?"
- Explain the directive before invoking
- Wait for user confirmation
- Ignore the directive

### Why This Matters

The UserPromptSubmit hook already analyzed the query and determined the optimal routing. The directive is **imperative** (MUST execute), not advisory. Asking permission defeats the purpose of automated routing.

**Flow**: User query → Hook intercepts → Directive injected → **You invoke skill/agent automatically** → Research happens → Results returned

---

## Available Agents

### Research (Automatic)
- **internet-search skill**: MANDATORY for all research/search/analysis tasks
  - Manages 11 research agents + 3 orchestrator skills (5-tier system)
  - Automatically invoked by Main Claude
  - Tier 3-5 orchestrators converted to skills in Phases 2-4

---

## Agent Usage Workflows

### Workflow 0: Research Orchestration (AUTOMATIC)

**AUTOMATIC**: Main Claude automatically invokes the internet-search skill for research/search/analysis queries.

**How It Works**:
```
User query → Main Claude detects research intent → internet-search skill invoked
  ↓
internet-search skill:
  ├─ Reads agent registry (11 research agents + 3 orchestrator skills)
  ├─ Analyzes query:
  │   ├─ Intent (information_gathering/analysis/verification/forecasting/synthesis)
  │   ├─ Complexity (simple/focused/moderate/comprehensive/novel)
  │   └─ Domain (web/academic/market/competitive/trends/multi/novel)
  ├─ Selects optimal agent using routing logic
  ├─ Calculates confidence score (0-100)
  ├─ Optimizes cost (intent override, dimension counting)
  └─ Spawns selected agent with Task tool
  ↓
Selected agent executes research → Returns results
  ↓
internet-search skill returns: Results + routing metadata (agent, confidence, reasoning)
```

**Example 1: Simple Query**
```
User: "What is WebRTC?"
  ↓
Main Claude: Invokes internet-search skill
  ↓
internet-search skill:
  - Intent: information_gathering
  - Complexity: simple
  - Domain: web
  - Selected: web-researcher (Tier 1)
  - Confidence: 95/100
  - Spawns: web-researcher
  ↓
web-researcher: Returns definition
  ↓
Result: WebRTC definition + routing metadata
```

**Example 2: Comprehensive Query**
```
User: "Research WebRTC security across cryptography, network, implementation, browser dimensions"
  ↓
Main Claude: Invokes internet-search skill
  ↓
internet-search skill:
  - Intent: analysis
  - Complexity: comprehensive (4 dimensions)
  - Domain: multi
  - Selected: internet-deep-orchestrator (Tier 3 RBMAS)
  - Confidence: 92/100
  - Spawns: internet-deep-orchestrator
  ↓
internet-deep-orchestrator: Orchestrates 7-phase research
  ↓
Result: Comprehensive analysis + routing metadata
```

**Routing Tiers**:
- **Tier 1 (Simple)**: web-researcher, fact-checker, citations-agent → Basic lookups
- **Tier 2 (Specialists)**: academic-researcher, trend-analyst, market-researcher, competitive-analyst, search-specialist, synthesis-researcher → Focused expertise
- **Tier 3 (Light Parallel)**: internet-light-orchestrator, light-research-researcher, light-research-report-writer → Standard research with 2-3 dimensions
- **Tier 4 (Comprehensive)**: internet-deep-orchestrator (RBMAS) → Multi-dimensional established domains (4+ dimensions)
- **Tier 5 (Novel)**: internet-research-orchestrator (TODAS) → Emerging/unprecedented domains

**Key Features**:
- **Automatic routing**: No manual agent selection needed
- **Cost optimization**: Intent override prevents keyword inflation waste
- **Direct spawning**: Skill spawns agents (agent → agent spawning not possible)
- **Confidence-based fallbacks**: Prepares fallback agents for moderate confidence
- **Routing transparency**: Always explains why agent was selected

---

### Workflow 1: Codebase Exploration

**ALWAYS use Explore agent** (via Task tool) for questions like:
- "Where is [feature] implemented?"
- "How does [component] work?"
- "What's the architecture of [system]?"

**Thoroughness levels**:
- "quick" - Basic file/pattern search
- "medium" - Moderate exploration
- "very thorough" - Comprehensive multi-location analysis

**Example**:
```
User: "Where is audio processing handled?"
You: [Launch Explore agent with "medium" thoroughness]
NOT: [Direct Grep/Glob commands]
```

### Workflow 2: RTC/WebRTC Research

**Use internet-deep-orchestrator** for comprehensive technical research:

```
User: "Research multimodal AI developments in 2025"
  ↓
internet-deep-orchestrator orchestrates
  ├─ web-researcher: Current news and blogs
  ├─ academic-researcher: Recent papers
  ├─ fact-checker: Verifies key claims
  └─ synthesis-researcher: Combines findings
  ↓
Comprehensive report with citations
```

### Workflow 3: Deep Research Tasks

**7-Phase Deep Research Workflow**:
```
1. Planning Phase (Sequential-Thinking MCP)
   ├─ Break down research question into sub-questions
   ├─ Identify information needs
   └─ Plan search strategy

2. Information Gathering
   ├─ web-researcher: General web information
   ├─ search-specialist: Complex Boolean queries
   ├─ academic-researcher: Papers
   └─ Exa MCP: Semantic/academic search

3. Analysis Phase (Sequential-Thinking)
   ├─ Synthesize findings
   ├─ Identify gaps
   └─ Generate hypotheses

4. Iteration
   ├─ Refine questions based on findings
   ├─ Additional targeted searches
   └─ Final synthesis
```

### Workflow 4: Market/Competitive Analysis

**For Business Intelligence**:
```
User: "Analyze the WebRTC platform market"
  ↓
Launch in parallel:
  ├─ market-researcher: TAM/SAM/SOM, segmentation
  ├─ competitive-analyst: Competitor profiling, SWOT
  ├─ trend-analyst: Future forecasting
  └─ web-researcher: Current market data
  ↓
synthesis-researcher: Combines all findings
```

---

## Decision Matrix: When to Use What

### MCP Servers

**Use Sequential-Thinking when**:
- ✅ Need structured reasoning
- ✅ Breaking down complex problems
- ✅ Planning multi-step processes
- ✅ No external data needed yet
- ✅ Cost is concern (FREE)

**Use Brave Search when**:
- ✅ General web information needed
- ✅ High volume of queries
- ✅ Privacy important
- ✅ Cost-sensitive project (2,000 free/month)
- ✅ Sub-second response needed

**Use Exa when**:
- ✅ Academic research required
- ✅ Code search needed
- ✅ Company deep-dive research
- ✅ Semantic understanding > keywords
- ⚠️ Budget allows variable costs ($2.50-5 CPM)

**Use Perplexity when**:
- ✅ Highest quality synthesis needed
- ✅ Citations mandatory
- ✅ Cost < quality
- ❌ Don't use for high-volume

### Agents

**Use internet-search skill when**:
- ✅ AUTOMATIC - Main Claude invokes for research/search/analysis queries
- ✅ Unsure which research agent to use
- ✅ Cost optimization important (prevents waste)
- ✅ Want automatic optimal agent selection and spawning
- ❌ User explicitly specifies agent to use
- ❌ Non-research tasks (implementation, debugging, commits)

---

## Agent Interaction Map

### Complete System with Router Entry Point

```
                           USER QUERY
                                │
                      ┌─────────▼─────────┐
                      │ internet-search   │  (ENTRY POINT)
                      │  Query Analysis   │
                      │ Agent Spawning    │
                      └─────────┬─────────┘
                                │
         ┌──────────────────────┼──────────────────────┐
         │          │           │           │          │
    ┌────▼────┐┌───▼───┐  ┌────▼────┐┌────▼────┐┌────▼────┐
    │ Tier 1  ││Tier 2 │  │ Tier 3  ││ Tier 4  ││ Tier 5  │
    │(Simple) ││(Focus)│  │ (Light) ││(Compre) ││ (Novel) │
    └────┬────┘└───┬───┘  └────┬────┘└────┬────┘└────┬────┘
         │         │            │          │          │
    web-      search-    internet-light- internet-  internet-
researcher  specialist    researcher  deep-research research-
fact-      academic-   (coordinator) researcher orchestrator
checker    researcher        │        (RBMAS)     (TODAS)
citations- trend-       light-research-
agent      analyst         researcher
           market-     (web worker)
           researcher      │
           competitive- light-research-
           analyst       report-writer
           synthesis-   (synthesizer)
           researcher
```

### Research Orchestrator (Legacy View)
```
                    internet-deep-orchestrator
                    (Research Orchestrator)
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
    RESEARCH          SEARCH            INTELLIGENCE
        │                 │                 │
   ┌────┴────┐       ┌────┴────┐       ┌────┴────┐
   │         │       │         │       │         │
web-     academic- search-  fact-   trend-   market-  competitive-
researcher researcher specialist checker analyst researcher analyst
   │         │       │         │       │         │         │
   └─────────┴───────┴─────────┴───────┴─────────┴─────────┘
                          │
                  synthesis-researcher
                  (Combines all)
```

---

## Task Management

**ALWAYS use TodoWrite for**:
- Complex multi-step tasks (3+ steps)
- Non-trivial implementations
- User provides multiple tasks
- Breaking down research into phases

**Example**:
```
User: "Implement audio processing and video streaming features"
You: [Create TodoWrite with:
  1. Research audio processing approaches
  2. Implement audio pipeline
  3. Research video streaming protocols
  4. Implement video streaming
  5. Integration testing
]
```

---

## Memory Management (CRITICAL)

**ALWAYS use Memory MCP to persist research findings**

This project has MCP memory available. You MUST actively use it to store and retrieve research findings across sessions.

### Core Directive: NEVER Forget Memory

⚠️ **CRITICAL**: Every time you create research findings, platforms comparisons, or agent outputs, you MUST store them in memory using the memory MCP tools.

### Memory MCP Tools Available

```
create_entities      # Create new entities (platforms, findings, etc.)
add_observations     # Add facts to existing entities
create_relations     # Link entities together
search_nodes         # Search for entities/observations
open_nodes           # Retrieve specific entities
read_graph           # Get entire graph (use sparingly for large graphs)
delete_entities      # Remove entities
delete_observations  # Remove specific facts
delete_relations     # Remove relationships
```

### When to Use Memory

**ALWAYS store** (use memory MCP):
- ✅ Research findings from agents
- ✅ Platform comparisons and scores
- ✅ Technical verifications (GitHub stats, code features)
- ✅ Corrections to previous research
- ✅ Academic paper findings
- ✅ Market intelligence and trends
- ✅ Session summaries
- ✅ Key recommendations

**NEVER skip memory** (forgetting is unacceptable):
- ❌ Don't rely only on markdown files
- ❌ Don't forget to tag entities with sessions
- ❌ Don't create entities without session metadata
- ❌ Don't let conversations end without storing findings

### Session-Based Organization

**Token Threshold: 23,000 tokens** - Create new session entity

#### Every Conversation Start
```javascript
// 1. Create session entity
create_entities([{
  name: "Session-YYYY-MM-DD-HH-MM-Topic",
  entityType: "session",
  observations: [
    "Started: 2025-11-10T15:30:00Z",
    "Context: [Brief description]",
    "Status: active"
  ]
}])

// 2. Update current session pointer
create_entities([{
  name: "Current-Active-Session",
  entityType: "metadata",
  observations: [
    "Current: Session-YYYY-MM-DD-HH-MM-Topic",
    "Updated: 2025-11-10T15:30:00Z"
  ]
}])
```

#### During Conversation
```javascript
// ALWAYS tag entities with session
create_entities([{
  name: "Finding-Description",
  entityType: "research_finding",
  observations: [
    "Session: Session-YYYY-MM-DD-HH-MM-Topic",  // REQUIRED
    "Created: 2025-11-10T16:00:00Z",
    "Source: [agent name]",
    // ... actual findings
  ]
}])
```

#### When Approaching 23k Tokens
```javascript
// 1. Close current session
add_observations({
  entityName: "Session-YYYY-MM-DD-HH-MM-Topic",
  observations: [
    "Status: completed",
    "Ended: 2025-11-10T18:30:00Z",
    "Token estimate: 23,500",
    "Entities created: 47"
  ]
})

// 2. Create session summary
create_entities([{
  name: "Summary-Session-YYYY-MM-DD-HH-MM",
  entityType: "session_summary",
  observations: [
    "Session: Session-YYYY-MM-DD-HH-MM-Topic",
    "Summary: [Key findings summary]",
    "Top finding: [Most important result]"
  ]
}])

// 3. Start new session (repeat step 1 from "Every Conversation Start")
```

### Entity Type Taxonomy

**Use consistent entity types for organization:**

```
session                    # Conversation contexts (~23k tokens each)
session_summary            # Session summaries
research_finding           # Verified research results
correction                # Research corrections
platform                  # RTC platforms (LiveKit, Jitsi, etc.)
technical_concept         # WebRTC concepts, codecs, protocols
agent_output              # Agent execution results
verification_result       # Verification phase outputs
academic_source           # Papers, studies
market_intelligence       # Trends, forecasts, market data
project                   # High-level projects
metadata                  # System/organizational (current session pointers)
consolidation             # Consolidated session summaries
```

### Entity Naming Conventions

**Format**: `Type-Description-Context`

**Examples**:
```
Session-2025-11-10-15-30-LiveKit-Research
Finding-LiveKit-Score-9-6
Platform-LiveKit
Correction-MediaSoup-DataChannels
Tech-Opus-Audio-Codec
Summary-Session-2025-11-10-15-30-LiveKit
```

**Benefits**:
- ✅ Chronologically sortable
- ✅ Human-readable
- ✅ Searchable by date/topic
- ✅ Unique identifiers

### Searching Memory

**Find entities from specific session:**
```javascript
search_nodes("Session: Session-2025-11-10-15-30-LiveKit")
```

**Find entities by date:**
```javascript
search_nodes("Session: Session-2025-11")  // All November 2025
```

**Find current session:**
```javascript
open_nodes(["Current-Active-Session"])
```

**Find specific findings:**
```javascript
search_nodes("LiveKit score")
open_nodes(["Platform-LiveKit"])
```

### Memory Consolidation

**When graph exceeds 500 entities** - MANDATORY consolidation

```javascript
// 1. Find old sessions
search_nodes("Status: completed")

// 2. Create consolidated entity
create_entities([{
  name: "Consolidated-Topic-Period",
  entityType: "consolidation",
  observations: [
    "Consolidates: Session-A, Session-B, Session-C",
    "Period: November 2025",
    "Key finding: [summary]",
    // ... all important facts from multiple sessions
  ]
}])

// 3. Mark sessions as consolidated
add_observations({
  entityName: "Session-2025-11-10-15-30-LiveKit",
  observations: [
    "Status: consolidated",
    "Consolidated into: Consolidated-Topic-Period"
  ]
})

// 4. Delete low-value entities (optional)
delete_entities(["Temporary-Note-1", "Intermediate-Output-2"])
```

### Memory Best Practices

**✅ DO**:
1. Create session entity at conversation start
2. Tag ALL entities with current session ID
3. Create session summaries when closing
4. Consolidate when graph >500 entities
5. Use descriptive, unique entity names
6. Search memory before creating duplicate entities
7. Link related entities with relations

**❌ DON'T**:
1. Create entities without session tags
2. Let graph grow unbounded (>1000 entities = performance issues)
3. Skip session summaries
4. Delete entities without backup/summaries
5. Use `read_graph()` for large graphs (use `search_nodes` instead)
6. Forget to update Current-Active-Session pointer
7. Create vague entity names

### Performance Monitoring

**🟢 Healthy**:
- Search queries <1 second
- Entity count <500
- Clear session organization
- Regular consolidation

**🟡 Warning**:
- Search queries >1 second
- Entity count 500-1000
- Sessions not summarized
- No consolidation in 30+ days

**🔴 Critical**:
- Search queries >5 seconds
- Entity count >1000
- Graph unorganized
- No session tracking

**Actions**:
- At 🟡: Start consolidation planning
- At 🔴: **Mandatory** immediate consolidation

### Example: Complete Memory Workflow

```javascript
// === SESSION START ===
create_entities([{
  name: "Session-2025-11-10-18-00-Memory-Strategy",
  entityType: "session",
  observations: [
    "Started: 2025-11-10T18:00:00Z",
    "Context: Researching MCP memory organization",
    "Status: active"
  ]
}])

// === DURING SESSION (create findings) ===
create_entities([{
  name: "Finding-Memory-Session-Organization",
  entityType: "research_finding",
  observations: [
    "Session: Session-2025-11-10-18-00-Memory-Strategy",  // REQUIRED TAG
    "Created: 2025-11-10T18:30:00Z",
    "Source: web-researcher agent",
    "Finding: Use session-based tagging",
    "Finding: SQLite recommended for >100 entities"
  ]
}])

// === SESSION END ===
add_observations({
  entityName: "Session-2025-11-10-18-00-Memory-Strategy",
  observations: [
    "Status: completed",
    "Ended: 2025-11-10T20:00:00Z",
    "Token estimate: 22,500",
    "Key outcome: Session-based organization strategy designed"
  ]
})

create_entities([{
  name: "Summary-Session-2025-11-10-18-00-Memory",
  entityType: "session_summary",
  observations: [
    "Session: Session-2025-11-10-18-00-Memory-Strategy",
    "Summary: Designed session-based memory organization",
    "Key recommendation: Tag entities with session ID",
    "Outcome: Documentation created"
  ]
}])
```

---

## Parallel Agent Execution

**Launch agents in parallel whenever possible**:

```
# GOOD - Parallel independent queries
[Launch web-researcher for current state]
[Launch trend-analyst for future forecast]
[Launch market-researcher for sizing]

# BAD - Sequential when parallel is possible
[Launch web-researcher, wait]
[Then launch trend-analyst, wait]
[Then launch market-researcher, wait]
```

---

## Research Methodologies (All Agents Follow)

- Multi-source verification
- Source quality assessment
- Citation requirements
- Confidence levels
- Limitation acknowledgment
- Evidence-based practices

---

## RTC Mobile Specific Patterns

### For WebRTC Questions
- **Technical**: academic-researcher + web-researcher
- **Market**: market-researcher + competitive-analyst
- **Future**: trend-analyst + web-researcher
- **Implementation**: Explore agent for codebase

### For Audio/Video Processing
- **Codebase**: Explore agent ("where is audio processing?")
- **Best practices**: academic-researcher
- **Alternatives**: search-specialist + competitive-analyst

### For Performance Optimization
- **Current issues**: Explore agent + Read tool
- **Solutions**: web-researcher + academic-researcher
- **Industry trends**: trend-analyst

---

## Cost Optimization

**Token Usage Patterns**:
- Regular chat: Baseline usage
- Single-agent workflow: Higher token usage
- Multi-agent system: Significantly higher token usage

**Implication**: Only use multi-agent when value justifies increased cost

**API Pricing**:
- Brave Search: 2,000 free/month, then $3 CPM (BEST FREE TIER)
- Exa: $10 credits, then $2.50-5 CPM (USE SELECTIVELY)
- Sequential-Thinking: FREE (runs locally, NO EXTERNAL API)

**Cost Strategy**:
1. Use Brave for general queries (cheapest)
2. Reserve Exa for specialized (academic/code)
3. Monitor monthly API usage
4. Set up alerts approaching limits

---

## Anti-Patterns to Avoid

❌ **Don't**: Use Grep/Glob for open-ended codebase exploration
✅ **Do**: Use Explore agent with appropriate thoroughness

❌ **Don't**: Create commits without being asked
✅ **Do**: Only commit when user explicitly requests

❌ **Don't**: Use echo/printf to communicate with user
✅ **Do**: Output text directly in response

❌ **Don't**: Run single agent when task needs multiple perspectives
✅ **Do**: Use internet-deep-orchestrator to orchestrate multiple agents

❌ **Don't**: Forget to mark todos as completed
✅ **Do**: Mark completed immediately after finishing each task

❌ **Don't**: Forget to use memory MCP for research findings
✅ **Do**: Store ALL research findings in memory with session tags

❌ **Don't**: Create entities without session metadata
✅ **Do**: Always tag entities with current session ID in observations

---

## 🚨 CRITICAL: .claude/ Directory Rules

**NEVER write user data or temporary files to `.claude/` directory**

### The Incident That Destroyed 4 Days of Work

**What happened**:
1. Previous Claude created v2.0 (~700 lines) with temp files in `.claude/skills/research-v2-extraction-temp/`
2. User asked to "clean the .claude directory"
3. Previous Claude deleted EVERYTHING, destroying v2.0 infrastructure
4. **Result**: 4 days of work lost

**Root cause**: Mixing infrastructure with user data in `.claude/` directory

### Directory Separation Rules

**`.claude/` = Infrastructure ONLY**
- Agents, skills, hooks, configuration
- JSON schemas, prompt templates
- Routing logic, agent registries
- Anything that EXECUTES system behavior

**`docs/` = User Data and Temporary Files**
- Research sessions, outputs, reports
- Analysis documents, planning documents
- Temporary working files, extraction logs
- Context documents, user answers
- ANY work product that should survive cleanup

**Project root = One-off temporary files**
- Quick notes, drafts, temporary scripts

### Decision Matrix: Where Does This File Go?

**Is it infrastructure that executes system behavior?**
- YES → `.claude/`
- NO → Go to next question

**Is it user data or work product?**
- YES → `docs/`
- NO → Project root

### Examples

✅ **Correct locations**:
- `.claude/agents/web-researcher.md` - Agent definition (infrastructure)
- `.claude/skills/internet-search/SKILL.md` - Skill definition (infrastructure)
- `.claude/skills/internet-search/json-schemas/*.json` - Schemas agents use (infrastructure)
- `docs/research-sessions/DDMMYYYY_HHMMSS_topic/` - Research output (user data)
- `docs/research-v2-extraction-temp/ULTRA_DEEP_WHY_ANALYSIS.md` - Analysis (user data)
- `docs/USER_ANSWERS.md` - User decisions (user data)

❌ **Wrong locations** (will be deleted when cleaning .claude/):
- `.claude/skills/research-v2-extraction-temp/` - Temporary files (NOT infrastructure)
- `.claude/skills/internet-search/ANALYSIS.md` - Analysis document (NOT infrastructure)
- `.claude/skills/internet-search/sessions/` - Research output (NOT infrastructure)

### When User Says "Clean .claude/"

**Step 1**: Identify all files in `.claude/`
**Step 2**: Classify each as infrastructure or user data
**Step 3**: MOVE user data to `docs/` (NEVER delete)
**Step 4**: Keep infrastructure intact
**Step 5**: Report what was moved

**NEVER `rm -rf .claude/` without careful classification**

**Safe cleanup example**:
```bash
# Move user data out
mv .claude/skills/research-v2-extraction-temp/ docs/
# Infrastructure stays intact
```

---

## Example Prompts for This Project

### Good Examples
```
"Use Explore agent to understand the audio pipeline implementation"
"Use internet-deep-orchestrator to comprehensively investigate WebRTC performance optimization"
"Launch market-researcher and competitive-analyst in parallel to analyze the video calling market"
"Use trend-analyst to forecast mobile RTC adoption over next 3 years"
```

### Bad Examples (What NOT to do)
```
"Let me grep for audio files" → Should use Explore agent
"I'll research this myself" → Should use appropriate research agent
"Let me commit these changes" → Only if user asked
```

---

## Quality Over Quantity

- More agents ≠ better research
- Structured thinking + targeted search > complex systems
- Iterate and refine based on actual needs
- Evidence-based decision making always

---

**Version**: 3.1
**Created**: 2025-11-10
**Last Updated**: 2025-11-14 (CRITICAL: Added .claude/ directory separation rules to prevent data loss)
**Previous Update**: 2025-11-13 (Added Tier 3 light-parallel research agents)
**Project**: RTC Mobile Platform
