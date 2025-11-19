#!/usr/bin/env bash
#
# PostToolUse Hook - Log tool call completion
# Called automatically by Claude Code after successful tool execution
#
# Input: JSON via stdin containing:
#   - tool_name: Name of the tool that was called
#   - tool_use_id: Unique identifier for this tool call
#   - tool_response: Output/result from the tool
#   - error: Error message if tool failed
#   - usage: Token usage statistics (if available)
#
# Output: JSON to stdout with:
#   - continue: true/false

set -euo pipefail

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Extract key fields
TOOL_USE_ID=$(echo "$HOOK_INPUT" | jq -r '.tool_use_id // "unknown"')
TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Determine logs directory from environment or default to project_logs
LOGS_DIR="${HOOKS_LOGS_DIR:-project_logs}"
mkdir -p "$LOGS_DIR"

# Log file paths
TOOL_LOG="$LOGS_DIR/tool_calls.jsonl"
TRANSCRIPT="$LOGS_DIR/transcript.txt"

# Check for errors
ERROR=$(echo "$HOOK_INPUT" | jq -r '.error // null')
SUCCESS="true"
if [ "$ERROR" != "null" ]; then
    SUCCESS="false"
fi

# Extract token usage if available
INPUT_TOKENS=$(echo "$HOOK_INPUT" | jq -r '.usage.input_tokens // 0')
OUTPUT_TOKENS=$(echo "$HOOK_INPUT" | jq -r '.usage.output_tokens // 0')

# Calculate output size
RESPONSE_SIZE=$(echo "$HOOK_INPUT" | jq -r '.tool_response | tostring | length')

# Write structured log entry (JSONL format)
cat >> "$TOOL_LOG" <<EOF
{"event":"tool_call_complete","timestamp":"$TIMESTAMP","tool_use_id":"$TOOL_USE_ID","tool_name":"$TOOL_NAME","success":$SUCCESS,"error":$ERROR,"output_size":$RESPONSE_SIZE,"input_tokens":$INPUT_TOKENS,"output_tokens":$OUTPUT_TOKENS}
EOF

# Write human-readable transcript entry
if [ "$SUCCESS" = "true" ]; then
    echo "[$TIMESTAMP] [$TOOL_USE_ID] ✓ Completed ($RESPONSE_SIZE bytes)" >> "$TRANSCRIPT"
    if [ "$INPUT_TOKENS" -gt 0 ]; then
        echo "    Tokens: ${INPUT_TOKENS}in / ${OUTPUT_TOKENS}out" >> "$TRANSCRIPT"
    fi
else
    echo "[$TIMESTAMP] [$TOOL_USE_ID] ✗ Failed: $ERROR" >> "$TRANSCRIPT"
fi

# Allow execution to continue
echo '{"continue": true}'
