#!/usr/bin/env bash
#
# SubagentStop Hook - Log subagent completion
# This is the ONLY hook that fires for subagents
#
# Input: JSON via stdin containing:
#   - session_id: Current session identifier
#   - transcript_path: Path to session transcript
#   - hook_event_name: "SubagentStop"
#
# Output: JSON to stdout with:
#   - continue: true/false

set -euo pipefail

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Extract key fields
SESSION_ID=$(echo "$HOOK_INPUT" | jq -r '.session_id // "default"')
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path // ""')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Determine logs directory from environment or default to project_logs
LOGS_DIR="${HOOKS_LOGS_DIR:-project_logs}"
mkdir -p "$LOGS_DIR"

# Log files
AGENT_MAP="$LOGS_DIR/agent_mapping.jsonl"
TRANSCRIPT="$LOGS_DIR/transcript.txt"

# State file for this session
STATE_FILE="/tmp/claude_agent_state_${SESSION_ID}.txt"

# Get the subagent type from state file (set by PreToolUse when Task spawned)
if [ -f "$STATE_FILE" ]; then
    AGENT_TYPE=$(cat "$STATE_FILE")
    AGENT_ID="$(echo "$AGENT_TYPE" | tr '[:lower:]' '[:upper:]')-1"  # Simplified - just use -1 for now

    # Find the most recent Task spawn in transcript to get timing
    if [ -f "$TRANSCRIPT_PATH" ] && [ -n "$TRANSCRIPT_PATH" ]; then
        # Find the most recent Task tool_use with this subagent_type
        TASK_TIMESTAMP=$(tail -r "$TRANSCRIPT_PATH" 2>/dev/null | \
            jq -r --arg subagent "$AGENT_TYPE" \
            'select(.message.content[]? | select(.type == "tool_use" and .name == "Task" and .input.subagent_type == $subagent)) | .timestamp' 2>/dev/null | \
            head -1)

        if [ -n "$TASK_TIMESTAMP" ] && [ "$TASK_TIMESTAMP" != "null" ]; then
            # Log the subagent completion with time range
            echo "[$TIMESTAMP] [SubagentStop] $AGENT_ID completed (spawned at $TASK_TIMESTAMP)" >> "$TRANSCRIPT"

            # Write agent mapping entry - this logs which agent was active during which time period
            cat >> "$AGENT_MAP" <<EOF
{"event":"subagent_stop","timestamp":"$TIMESTAMP","agent_id":"$AGENT_ID","agent_type":"$AGENT_TYPE","task_spawn_time":"$TASK_TIMESTAMP","session_id":"$SESSION_ID"}
EOF
        else
            echo "[$TIMESTAMP] [SubagentStop] $AGENT_ID completed (Task spawn time unknown)" >> "$TRANSCRIPT"
        fi
    else
        echo "[$TIMESTAMP] [SubagentStop] $AGENT_ID completed (no transcript available)" >> "$TRANSCRIPT"
    fi

    # Clean up state file
    rm -f "$STATE_FILE"
else
    # No state file - unknown subagent
    echo "[$TIMESTAMP] [SubagentStop] Unknown subagent completed" >> "$TRANSCRIPT"
fi

# Allow execution to continue
echo '{"continue": true}'
