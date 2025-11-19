#!/usr/bin/env bash
#
# Multi-Agent Research System - Centralized Configuration
# =======================================================
#
# This file provides centralized path configuration for all agents, hooks, and skills.
# Source this file to get dynamic paths instead of hardcoded values.
#
# Based on learnings from: Claude-Multi-Agent-Research-System-Skill
# Created: 2025-11-19
# Version: 2.0 (Refactored: removed legacy RTC_ prefix)

# ===========================
# Project Root Detection
# ===========================

# Detect project root dynamically
# Priority:
# 1. PROJECT_ROOT environment variable (if set)
# 2. Walk up from current script's directory to find .claude/ directory
# 3. Fall back to current working directory

if [ -n "${PROJECT_ROOT:-}" ]; then
    # User explicitly set project root - use as-is
    :  # No-op, PROJECT_ROOT already set
elif [ -n "${BASH_SOURCE[0]:-}" ]; then
    # Script is being sourced - find .claude/ parent directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # SCRIPT_DIR should be .claude/, parent is project root
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
else
    # Fallback: current working directory
    PROJECT_ROOT="$(pwd)"
fi

# Validate project root has .claude/ directory
if [ ! -d "$PROJECT_ROOT/.claude" ]; then
    echo "WARNING: .claude/ directory not found at $PROJECT_ROOT" >&2
    echo "Set PROJECT_ROOT environment variable or run from project root" >&2
fi

# ===========================
# Path Configuration
# ===========================

# Core directories
export CLAUDE_DIR="$PROJECT_ROOT/.claude"
export AGENTS_DIR="$CLAUDE_DIR/agents"
export SKILLS_DIR="$CLAUDE_DIR/skills"
export HOOKS_DIR="$CLAUDE_DIR/hooks"
export PROMPTS_DIR="$CLAUDE_DIR/prompts"

# Runtime logs (gitignored)
export LOGS_DIR="${LOGS_DIR:-$PROJECT_ROOT/project_logs}"
export AGENT_START_LOG="$LOGS_DIR/agent_start_log.jsonl"
export TOOL_CALLS_LOG="$LOGS_DIR/tool_calls.jsonl"
export AGENT_MAPPING_LOG="$LOGS_DIR/agent_mapping.jsonl"
export TRANSCRIPT_LOG="$LOGS_DIR/transcript.txt"
export ROUTER_LOG="$LOGS_DIR/router-log.jsonl"

# Research output directories (committed)
export DOCS_DIR="$PROJECT_ROOT/docs"
export RESEARCH_SESSIONS_DIR="$DOCS_DIR/research-sessions"
export MEMORY_DIR="$PROJECT_ROOT/memory"

# MCP and state directories (gitignored)
export MCP_MEMORY_DIR="$CLAUDE_DIR/memory"
export STATE_DIR="$CLAUDE_DIR/state"

# ===========================
# Logging Configuration
# ===========================

# Logging enabled by default (set LOGGING_ENABLED=false to disable)
export LOGGING_ENABLED="${LOGGING_ENABLED:-true}"
export LOG_TOOL_CALLS="${LOG_TOOL_CALLS:-true}"
export LOG_AGENT_STARTS="${LOG_AGENT_STARTS:-true}"

# ===========================
# Research Configuration
# ===========================

# Maximum parallel researchers (for orchestrators)
export MAX_PARALLEL_RESEARCHERS="${MAX_PARALLEL_RESEARCHERS:-4}"

# Default model for agents (can be overridden per agent)
export DEFAULT_MODEL="${DEFAULT_MODEL:-sonnet}"

# ===========================
# Helper Functions
# ===========================

# Ensure log directory exists
ensure_logs_dir() {
    mkdir -p "$LOGS_DIR"
}

# Ensure research sessions directory exists
ensure_research_dir() {
    mkdir -p "$RESEARCH_SESSIONS_DIR"
}

# Get absolute path for a relative path
abs_path() {
    local rel_path="$1"
    echo "$PROJECT_ROOT/$rel_path"
}

# Log agent startup (for use in agent scripts)
log_agent_start() {
    local agent_name="$1"
    local agent_id="${2:-$(echo "$agent_name" | tr '[:lower:]' '[:upper:]')-$(date +%s)}"
    local spawned_by="${SPAWNED_BY:-MAIN}"
    local invocation_context="${INVOCATION_CONTEXT:-direct}"
    local session_id="${SESSION_ID:-unknown}"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    ensure_logs_dir

    if [ "$LOG_AGENT_STARTS" = "true" ]; then
        echo "{\"event\":\"agent_start\",\"agent_name\":\"$agent_name\",\"agent_id\":\"$agent_id\",\"timestamp\":\"$timestamp\",\"session_id\":\"$session_id\",\"spawned_by\":\"$spawned_by\",\"invocation_context\":\"$invocation_context\"}" >> "$AGENT_START_LOG"
    fi
}

# ===========================
# Configuration Summary
# ===========================

# Print configuration (for debugging)
print_config() {
    cat <<EOF
Multi-Agent Research System Configuration
==========================================

Project Root: $PROJECT_ROOT

Core Directories:
  .claude/       : $CLAUDE_DIR
  agents/        : $AGENTS_DIR
  skills/        : $SKILLS_DIR
  hooks/         : $HOOKS_DIR

Runtime Logs (gitignored):
  logs/          : $LOGS_DIR
  agent_start_log: $AGENT_START_LOG
  tool_calls_log : $TOOL_CALLS_LOG
  router_log     : $ROUTER_LOG

Research Output (committed):
  docs/          : $DOCS_DIR
  research/      : $RESEARCH_SESSIONS_DIR

Configuration:
  Logging enabled: $LOGGING_ENABLED
  Max parallel   : $MAX_PARALLEL_RESEARCHERS
  Default model  : $DEFAULT_MODEL

EOF
}

# ===========================
# Auto-initialization
# ===========================

# Ensure critical directories exist
ensure_logs_dir
ensure_research_dir

# Export PROJECT_ROOT for child processes
export PROJECT_ROOT

# Configuration loaded successfully
# (Uncomment for debugging)
# echo "✓ Multi-Agent Research System config loaded from: ${BASH_SOURCE[0]}" >&2
