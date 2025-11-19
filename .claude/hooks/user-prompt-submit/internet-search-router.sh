#!/bin/bash
# .claude/hooks/user-prompt-submit/internet-search-router.sh
# UserPromptSubmit hook that analyzes research queries and routes to appropriate tier
#
# Purpose: Route research queries to correct tier skills (3-5) or agents (1-2)
# Created: 2025-11-16
# Migration Plan: docs/hook-migration-tests/IMPLEMENTATION_PLAN.md
# Conversion Map: docs/hook-migration-tests/SKILL_TO_HOOK_CONVERSION_MAP.md

# Input: JSON from stdin with user prompt text
# Output: Amended prompt with routing directive (or original if not research query)
# Exit code 0: stdout shown to Claude

# Read JSON input from stdin
INPUT_JSON=$(cat)

# Extract user prompt text from JSON
# Handle both potential JSON formats: {"text": "..."} or {"prompt": "..."} or direct string
QUERY=$(echo "$INPUT_JSON" | jq -r '.text // .prompt // .' 2>/dev/null)

# If jq parsing failed or empty, fall back to treating input as plain text
if [ -z "$QUERY" ] || [ "$QUERY" = "null" ]; then
    QUERY="$INPUT_JSON"
fi

# ========================================
# HELPER FUNCTIONS
# ========================================

is_research_query() {
    local query="$1"

    # Check for research-related keywords (base forms + derivatives)
    # Covers: research(ing|ed), investigat(e|ing|ed), analyz(e|ing|ed), search(|ing|ed), etc.
    if echo "$query" | grep -iE "research(ing|ed)?|investigat(e|ing|ed)|analyz(e|ing|ed)|search(ing|ed)?|stud(y|ying|ied)|explor(e|ing|ed)|examin(e|ing|ed)" >/dev/null; then
        return 0  # true
    fi

    # Check for additional research synonyms and derivatives
    # Covers: discover(|ing|ed), learn(|ing|ed), gather(|ing|ed), assess(|ing|ed), evaluat(e|ing|ed), review(|ing|ed)
    if echo "$query" | grep -iE "discover(ing|ed)?|learn(ing|ed)?|gather(ing|ed)?|assess(ing|ed)?|evaluat(e|ing|ed)|review(ing|ed)?|compar(e|ing|ed)" >/dev/null; then
        return 0  # true
    fi

    # Check for research-related phrases
    # Covers: "find information", "look up", "gather data", "search for"
    if echo "$query" | grep -iE "find.*(information|data|details)|look.*(up|into)|gather.*(data|information)|search.*(for|about)" >/dev/null; then
        return 0  # true
    fi

    # Check for question patterns
    if echo "$query" | grep -iE "what|how|why|when|where|who|which" >/dev/null; then
        return 0  # true
    fi

    # Not a research query
    return 1  # false
}

is_specialist_query() {
    local query="$1"

    # Check if query needs specific domain expertise
    if echo "$query" | grep -iE "paper|study|academic|market|TAM|SAM|competitor|SWOT|trend|forecast|search.?specialist" >/dev/null; then
        return 0  # true
    fi

    return 1  # false
}

generate_topic_slug() {
    local query="$1"

    # Convert query to URL-friendly slug
    # "Research cloud gaming" → "cloud_gaming"
    echo "$query" | \
        tr '[:upper:]' '[:lower:]' | \
        sed 's/[^a-z0-9]/_/g' | \
        sed 's/__*/_/g' | \
        sed 's/^_//;s/_$//' | \
        cut -c1-50
}

# ========================================
# QUERY ANALYSIS FUNCTIONS
# ========================================

analyze_intent() {
    local query="$1"

    # Check for verification keywords
    if echo "$query" | grep -iE "verify|fact.?check|is.?true|correct|accurate|validate" >/dev/null; then
        echo "verification"
        return
    fi

    # Check for forecasting keywords
    if echo "$query" | grep -iE "forecast|predict|future|trend|will.?happen|next.*years?|upcoming|emerging" >/dev/null; then
        echo "forecasting"
        return
    fi

    # Check for synthesis keywords
    if echo "$query" | grep -iE "synthesize|combine|compare.*contrast|summarize.*from|integrate.*findings" >/dev/null; then
        echo "synthesis"
        return
    fi

    # Check for analysis keywords
    if echo "$query" | grep -iE "analyze|investigate|deep.*dive|comprehensive|examine|evaluate" >/dev/null; then
        echo "analysis"
        return
    fi

    # Default: information gathering
    echo "information_gathering"
}

analyze_complexity() {
    local query="$1"
    local dimensions=$(count_dimensions "$query")

    # Novel domain detection
    if echo "$query" | grep -iE "emerging|new|novel|unprecedented|cutting.?edge|bleeding.?edge|next.?generation" >/dev/null; then
        echo "novel"
        return
    fi

    # Dimension-based complexity
    if [ "$dimensions" -ge 4 ]; then
        echo "comprehensive"
    elif [ "$dimensions" -eq 2 ] || [ "$dimensions" -eq 3 ]; then
        echo "moderate"
    else
        # Check if single domain specialist needed
        if is_specialist_query "$query"; then
            echo "focused"
        else
            echo "simple"
        fi
    fi
}

analyze_domain() {
    local query="$1"

    # Academic keywords
    if echo "$query" | grep -iE "paper|research.*study|academic|peer.?review|literature|scholarly|publication" >/dev/null; then
        echo "academic"
        return
    fi

    # Market keywords
    if echo "$query" | grep -iE "market|TAM|SAM|SOM|market.?size|market.?share|segment|consumer|customer" >/dev/null; then
        echo "market"
        return
    fi

    # Competitive keywords
    if echo "$query" | grep -iE "competitor|competitive|SWOT|position|landscape|rivalry|industry.?analysis" >/dev/null; then
        echo "competitive"
        return
    fi

    # Trends keywords
    if echo "$query" | grep -iE "trend|forecast|future|predict|emerging|pattern|evolution|trajectory" >/dev/null; then
        echo "trends"
        return
    fi

    # Default: web
    echo "web"
}

count_dimensions() {
    local query="$1"
    local count=1

    # Count explicit dimensions (separated by "and", commas, semicolons)
    # "Research quantum computing hardware and algorithms" = 2 dimensions
    # "Analyze market, competitors, and trends" = 3 dimensions

    # Count "and" separators
    local and_count=$(echo "$query" | grep -o " and " | wc -l | tr -d ' ')
    count=$((count + and_count))

    # Count comma separators
    local comma_count=$(echo "$query" | grep -o "," | wc -l | tr -d ' ')
    count=$((count + comma_count))

    # Count semicolon separators
    local semi_count=$(echo "$query" | grep -o ";" | wc -l | tr -d ' ')
    count=$((count + semi_count))

    # Cap at reasonable max
    if [ "$count" -gt 10 ]; then
        count=10
    fi

    echo "$count"
}

# ========================================
# ROUTING FUNCTIONS
# ========================================

route_to_tier() {
    local intent="$1"
    local complexity="$2"
    local domain="$3"
    local dimensions="$4"

    # Tier 5: Novel domains
    if [ "$complexity" = "novel" ]; then
        echo "5"
        return
    fi

    # Tier 4: Comprehensive (4+ dimensions)
    if [ "$complexity" = "comprehensive" ] || [ "$dimensions" -ge 4 ]; then
        echo "4"
        return
    fi

    # Tier 3: Moderate (2-3 dimensions)
    if [ "$complexity" = "moderate" ] || [ "$dimensions" -eq 2 ] || [ "$dimensions" -eq 3 ]; then
        echo "3"
        return
    fi

    # Tier 2: Focused specialist
    if [ "$complexity" = "focused" ]; then
        echo "2"
        return
    fi

    # Tier 1: Simple
    echo "1"
}

select_specialist() {
    local domain="$1"

    case "$domain" in
        academic)
            echo "academic-researcher"
            ;;
        market)
            echo "market-researcher"
            ;;
        competitive)
            echo "competitive-analyst"
            ;;
        trends)
            echo "trend-analyst"
            ;;
        *)
            echo "web-researcher"
            ;;
    esac
}

optimize_routing() {
    local query="$1"
    local tier="$2"

    # Intent override: Check if inflated keywords with simple intent
    if echo "$query" | grep -iE "comprehensive|thorough|in.?depth|extensive|detailed" >/dev/null; then
        # Check if actually asking simple question
        if echo "$query" | grep -iE "what is|define|meaning of|stands for|definition" >/dev/null; then
            # Override to Tier 1 (simple lookup)
            echo "1"
            return
        fi
    fi

    # Otherwise use original tier
    echo "$tier"
}

generate_directive() {
    local tier="$1"
    local dimensions="$2"
    local domain="$3"

    case "$tier" in
        1)
            echo "This is a simple lookup. Use web-researcher agent directly."
            ;;
        2)
            local agent=$(select_specialist "$domain")
            echo "This requires domain expertise. Use $agent agent."
            ;;
        3)
            echo "Use internet-light-orchestrator skill. It is a tier 3 skill to coordinate parallel researchers, and report-writers."
            ;;
        4)
            echo "This is a comprehensive multi-dimensional query. Use internet-deep-orchestrator skill for 7-phase RBMAS research."
            ;;
        5)
            echo "This is a novel/emerging domain query. Use internet-research-orchestrator skill for adaptive TODAS research."
            ;;
    esac
}

# ========================================
# LOGGING FUNCTION
# ========================================

log_routing_decision() {
    local query="$1"
    local tier="$2"
    local intent="$3"
    local complexity="$4"
    local domain="$5"
    local dimensions="$6"
    local directive="$7"

    # Create log directory if it doesn't exist
    mkdir -p docs/hook-migration-tests

    # Log routing decision in JSONL format using jq for proper JSON escaping
    # -c flag ensures compact single-line output (required for JSONL)
    jq -nc \
        --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        --arg query "$query" \
        --argjson tier "$tier" \
        --arg intent "$intent" \
        --arg complexity "$complexity" \
        --arg domain "$domain" \
        --argjson dimensions "$dimensions" \
        --arg directive "$directive" \
        '{timestamp: $timestamp, query: $query, tier: $tier, intent: $intent, complexity: $complexity, domain: $domain, dimensions: $dimensions, directive: $directive}' \
        >> project_logs/router-log.jsonl
}

# ========================================
# MAIN SCRIPT LOGIC
# ========================================

# Check if query is research-related
if ! is_research_query "$QUERY"; then
    # Not research query - pass through unchanged
    echo "$QUERY"
    exit 0
fi

# Perform query analysis
INTENT=$(analyze_intent "$QUERY")
COMPLEXITY=$(analyze_complexity "$QUERY")
DOMAIN=$(analyze_domain "$QUERY")
DIMENSIONS=$(count_dimensions "$QUERY")

# Determine tier
TIER=$(route_to_tier "$INTENT" "$COMPLEXITY" "$DOMAIN" "$DIMENSIONS")

# Apply cost optimization (intent override)
TIER=$(optimize_routing "$QUERY" "$TIER")

# Generate directive
DIRECTIVE=$(generate_directive "$TIER" "$DIMENSIONS" "$DOMAIN")

# Generate session path
SESSION_ID="$(date +%d%m%Y_%H%M%S)_$(generate_topic_slug "$QUERY")"
SESSION_PATH="docs/research-sessions/$SESSION_ID/"

# Log routing decision
log_routing_decision "$QUERY" "$TIER" "$INTENT" "$COMPLEXITY" "$DOMAIN" "$DIMENSIONS" "$DIRECTIVE"

# Output amended prompt with routing directive
cat <<EOF
$QUERY

---
[ROUTING DIRECTIVE]
$DIRECTIVE

Research Path: $SESSION_PATH
Tier: $TIER
Intent: $INTENT
Complexity: $COMPLEXITY
Domain: $DOMAIN
Dimensions: $DIMENSIONS
EOF
