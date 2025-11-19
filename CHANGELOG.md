# Changelog

All notable changes to the Multi-Agent Research System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-11-19

### Added
- **5-Tier Adaptive Routing System**
  - Tier 1: Simple lookups (web-researcher, fact-checker, citations-agent)
  - Tier 2: Specialist agents (academic, market, trend, competitive, search, synthesis)
  - Tier 3: Light parallel orchestration (2-3 dimensions)
  - Tier 4: Comprehensive RBMAS research (4+ dimensions)
  - Tier 5: Novel domain TODAS research (emerging topics)

- **13 Specialized Research Agents**
  - 11 specialist agents for different research domains
  - Explore agent for codebase navigation
  - research-subagent for general research tasks

- **3 Orchestrator Skills**
  - `internet-research-orchestrator` (Tier 5 - TODAS methodology)
  - `internet-deep-orchestrator` (Tier 4 - RBMAS methodology)
  - `internet-light-orchestrator` (Tier 3 - Light parallel)

- **MCP Integration**
  - Sequential Thinking MCP for structured reasoning
  - Brave Search MCP for cost-effective web search
  - Exa MCP for academic/semantic search
  - Perplexity MCP for high-quality synthesis
  - Memory MCP for persistent knowledge graphs

- **Automated Routing**
  - UserPromptSubmit hook with intelligent query analysis
  - Confidence-based agent selection (0-100 scoring)
  - Cost optimization via intent override
  - Dimension counting for orchestration validation

- **Monitoring Infrastructure**
  - Tool call logging (project_logs/tool_calls.jsonl)
  - Agent startup tracking (project_logs/agent_start_log.jsonl)
  - Router decision logging (project_logs/router-log.jsonl)
  - Allocation decision tracking for Tier 5

- **Session-Based Memory Management**
  - 23k token session threshold
  - Entity tagging with session IDs
  - Consolidation workflows for >500 entities
  - Performance monitoring

### Changed
- Project renamed from `rtc_mobile` to `multi-agent-research`
- Restructured as general-purpose research system (not RTC-specific)
- Migrated to session-based allocation decision logging

### Fixed
- MAX_PARALLEL_RESEARCHERS reduced from 7 to 4 (prevents Bun segfaults)
- Added mandatory checkpoint verification for allocation decision files
- Improved session-based allocation decision logging

### Deprecated
- None

### Removed
- Archived original RTC research to external archive
- Removed outdated memory documentation snapshots

### Security
- Comprehensive .gitignore for environment variables and secrets
- Security audit hook recommendations

### License
- MIT License for maximum permissiveness and community adoption

---

## Version History

- **v1.0.0**: First public release (November 19, 2025)

[Unreleased]: https://github.com/ahmedibrahim085/multi-agent-research/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/ahmedibrahim085/multi-agent-research/releases/tag/v1.0.0
