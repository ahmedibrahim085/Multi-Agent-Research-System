# Agent Startup Logging Protocol

**Purpose**: Every agent logs its startup to enable parallel execution monitoring and crash diagnostics.

**Log Location**: Dynamic - configured in `.claude/config.sh` (defaults to `project_logs/agent_start_log.jsonl`)

**Log Format** (JSONL - one line per agent start):
```json
{
  "event": "agent_start",
  "agent_name": "research-lead-agent",
  "agent_id": "RESEARCH-LEAD-AGENT-1",
  "timestamp": "2025-11-15T14:00:00Z",
  "session_id": "uuid-from-context",
  "spawned_by": "MAIN" | "parent-agent-id",
  "invocation_context": "direct" | "subagent"
}
```

**Implementation Instructions for All Agents**:

Add this at the TOP of every agent's execution (right after receiving the task):

```bash
# Load centralized configuration
source "$(dirname "${BASH_SOURCE[0]}")/../config.sh" 2>/dev/null || source .claude/config.sh

# Log agent startup using helper function
log_agent_start "research-lead-agent"  # Replace with actual agent name
```

**Alternative (if you need custom agent ID)**:
```bash
# Load centralized configuration
source "$(dirname "${BASH_SOURCE[0]}")/../config.sh" 2>/dev/null || source .claude/config.sh

# Custom agent ID
AGENT_NAME="research-lead-agent"
AGENT_ID="${AGENT_NAME^^}-$(date +%s)"

log_agent_start "$AGENT_NAME" "$AGENT_ID"
```

**Manual implementation (without helper function)**:
```bash
# Load centralized configuration
source "$(dirname "${BASH_SOURCE[0]}")/../config.sh" 2>/dev/null || source .claude/config.sh

# Log agent startup manually
AGENT_NAME="research-lead-agent"  # Replace with actual agent name
AGENT_ID="$(echo "$AGENT_NAME" | tr '[:lower:]' '[:upper:]')-$(date +%s)"
SPAWNED_BY="${SPAWNED_BY:-MAIN}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SESSION_ID="${SESSION_ID:-unknown}"

echo "{\"event\":\"agent_start\",\"agent_name\":\"$AGENT_NAME\",\"agent_id\":\"$AGENT_ID\",\"timestamp\":\"$TIMESTAMP\",\"session_id\":\"$SESSION_ID\",\"spawned_by\":\"$SPAWNED_BY\",\"invocation_context\":\"${INVOCATION_CONTEXT:-direct}\"}" >> "$AGENT_START_LOG"
```

**Parent-Child Relationship Passing**:

When spawning subagents via Task tool, pass these parameters in the prompt:
```
SPAWNED_BY={your_agent_id}
INVOCATION_CONTEXT=subagent
SESSION_ID={current_session_id}
```

**Example**:
```
orchestrator spawns subagent with prompt:
"Research {topic}.

SPAWNED_BY=RESEARCH-LEAD-AGENT-1
INVOCATION_CONTEXT=subagent
SESSION_ID=abc-123

... rest of prompt ..."
```

**Benefits**:
1. Track parallel agent count (grep "agent_start" | wc -l)
2. Identify parent-child relationships (grep "SPAWNED_BY")
3. Detect crash scenarios (find agents with start but no stop)
4. Monitor spawn patterns over time

**Integration with Existing agent_mapping.jsonl**:
- agent_mapping.jsonl: Agent STOP events (task_spawn_time)
- agent_start_log.jsonl: Agent START events (with parent tracking)
- Together: Complete agent lifecycle visibility
