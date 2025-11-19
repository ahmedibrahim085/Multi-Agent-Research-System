#!/usr/bin/env bash
#
# PreToolUse Hook - Log tool call initiation
# Called automatically by Claude Code before any tool execution
#
# Input: JSON via stdin containing:
#   - tool_name: Name of the tool being called
#   - tool_input: Parameters passed to the tool
#   - tool_use_id: Unique identifier for this tool call
#   - session_id: Current session identifier
#   - transcript_path: Path to session transcript JSONL [if available]
#
# Output: JSON to stdout with:
#   - continue: true/false (whether to proceed with tool execution)

set -euo pipefail

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Extract key fields
TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name // "unknown"')
TOOL_USE_ID=$(echo "$HOOK_INPUT" | jq -r '.tool_use_id // "unknown"')
SESSION_ID=$(echo "$HOOK_INPUT" | jq -r '.session_id // "default"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Determine logs directory from environment or default to project_logs
LOGS_DIR="${HOOKS_LOGS_DIR:-project_logs}"
mkdir -p "$LOGS_DIR"

# Log file paths
TOOL_LOG="$LOGS_DIR/tool_calls.jsonl"
TRANSCRIPT="$LOGS_DIR/transcript.txt"

# State file for tracking current subagent
STATE_FILE="/tmp/claude_agent_state_${SESSION_ID}.txt"

# Determine agent ID using STATE FILE approach
AGENT_ID="MAIN"
AGENT_TYPE="MAIN"

# If this is a Task spawn, set the state for subsequent calls
if [ "$TOOL_NAME" = "Task" ]; then
    SUBAGENT_TYPE=$(echo "$HOOK_INPUT" | jq -r '.tool_input.subagent_type // "unknown"')
    if [ "$SUBAGENT_TYPE" != "unknown" ]; then
        # Write state file for subsequent tool calls
        echo "$SUBAGENT_TYPE" > "$STATE_FILE"
        AGENT_TYPE="$SUBAGENT_TYPE"
        # Count existing agents of this type to generate ID
        COUNT=$(grep -c "\"agent_type\":\"$AGENT_TYPE\"" "$TOOL_LOG" 2>/dev/null || echo 0)
        AGENT_ID="$(echo "$AGENT_TYPE" | tr '[:lower:]' '[:upper:]')-$((COUNT + 1))"
    fi
else
    # For non-Task tools, check if we're inside a subagent context
    if [ -f "$STATE_FILE" ]; then
        AGENT_TYPE=$(cat "$STATE_FILE")
        # Count existing agents of this type to generate ID
        COUNT=$(grep -c "\"agent_type\":\"$AGENT_TYPE\"" "$TOOL_LOG" 2>/dev/null || echo 0)
        AGENT_ID="$(echo "$AGENT_TYPE" | tr '[:lower:]' '[:upper:]')-$((COUNT + 1))"
    fi
fi

# Format tool input for logging (truncate if too long)
TOOL_INPUT_STR=$(echo "$HOOK_INPUT" | jq -c '.tool_input')
if [ ${#TOOL_INPUT_STR} -gt 200 ]; then
    TOOL_INPUT_SHORT="${TOOL_INPUT_STR:0:200}..."
else
    TOOL_INPUT_SHORT="$TOOL_INPUT_STR"
fi

# Write structured log entry (JSONL format)
cat >> "$TOOL_LOG" <<EOF
{"event":"tool_call_start","timestamp":"$TIMESTAMP","tool_use_id":"$TOOL_USE_ID","agent_id":"$AGENT_ID","agent_type":"$AGENT_TYPE","tool_name":"$TOOL_NAME","session_id":"$SESSION_ID","tool_input":$TOOL_INPUT_STR}
EOF

# Write human-readable transcript entry
echo "[$TIMESTAMP] [$AGENT_ID] → $TOOL_NAME" >> "$TRANSCRIPT"
if [ "$TOOL_NAME" = "WebSearch" ]; then
    QUERY=$(echo "$HOOK_INPUT" | jq -r '.tool_input.query // ""')
    echo "    Query: $QUERY" >> "$TRANSCRIPT"
elif [ "$TOOL_NAME" = "Task" ]; then
    DESC=$(echo "$HOOK_INPUT" | jq -r '.tool_input.description // ""')
    SUBAGENT=$(echo "$HOOK_INPUT" | jq -r '.tool_input.subagent_type // ""')
    echo "    Spawning: $DESC ($SUBAGENT)" >> "$TRANSCRIPT"
fi

# Allow tool execution to continue
echo '{"continue": true}'
