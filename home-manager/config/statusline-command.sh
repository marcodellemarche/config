#!/usr/bin/env bash
input=$(cat)

# --- Parse all values in a single jq call ---
parsed=$(echo "$input" | jq -r '
  (.workspace.current_dir // .cwd // "?") as $cwd |
  (.context_window.used_percentage // 0) as $used_pct |
  (.context_window.context_window_size // 0) as $ctx_size |
  (.cost.total_cost_usd // 0) as $cost |
  (.rate_limits.five_hour.used_percentage // -1) as $rate_pct |
  (.rate_limits.five_hour.resets_at // -1) as $rate_reset |
  (.model.display_name // "") as $model |
  (($used_pct * $ctx_size / 100 / 1000) | floor) as $used_k |
  ($ctx_size / 1000 | floor) as $total_k |
  [$cwd, ($used_pct|tostring), ($ctx_size|tostring), ($used_k|tostring), ($total_k|tostring), ($cost|tostring), ($rate_pct|tostring), ($rate_reset|tostring), $model]
  | join("\t")
')

IFS=$'\t' read -r cwd used_pct ctx_size used_k total_k cost rate_pct rate_reset model <<< "$parsed"

dir=$(basename "$cwd")

# --- ANSI helpers ---
RESET=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
BOLD_GREEN=$'\033[01;32m'
BOLD_BLUE=$'\033[01;34m'

# --- Context bar color ---
used_int=${used_pct%.*}
used_int=${used_int:-0}
if [ "$used_int" -ge 90 ] 2>/dev/null; then
  bar_color=$RED
elif [ "$used_int" -ge 70 ] 2>/dev/null; then
  bar_color=$YELLOW
else
  bar_color=$GREEN
fi

# --- Build 10-segment bar ---
filled=$(( used_int * 10 / 100 ))
[ "$filled" -gt 10 ] && filled=10
empty=$(( 10 - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar="${bar}█"; done
for ((i=0; i<empty; i++));  do bar="${bar}░"; done

# --- Format context section ---
ctx_section=$(printf "${bar_color}${BOLD}%s${RESET} ${bar_color}${BOLD}%d%%${RESET} ${DIM}(%dk/%dk)${RESET}" \
  "$bar" "$used_int" "$used_k" "$total_k")

# --- Format cost section ---
cost_section=$(LC_NUMERIC=C printf "${YELLOW}\$%.4f${RESET}" "$cost")

# --- Format rate limit section ---
rate_section=""
if [ "$rate_pct" != "-1" ] && [ "$rate_pct" != "null" ]; then
  rate_int=$(echo "$rate_pct" | awk '{printf "%d", $1}')
  now=$(date +%s)
  mins_left=$(( (rate_reset - now) / 60 ))
  [ "$mins_left" -lt 0 ] && mins_left=0
  if [ "$rate_int" -ge 80 ]; then
    rate_color=$RED
  elif [ "$rate_int" -ge 50 ]; then
    rate_color=$YELLOW
  else
    rate_color=$GREEN
  fi
  rate_section=$(printf " ${DIM}│${RESET} ${rate_color}rate %d%% (%dm)${RESET}" "$rate_int" "$mins_left")
fi

# --- Single line: repo + model + context + cost + rate ---
header="${BOLD_BLUE}${dir}${RESET}"
[ -n "$model" ] && header="${header} ${DIM}[${model}]${RESET}"
printf "%s ${DIM}│${RESET} %s ${DIM}│${RESET} %s%s\n" "$header" "$ctx_section" "$cost_section" "$rate_section"
