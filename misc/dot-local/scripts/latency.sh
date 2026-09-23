#!/bin/bash
# Measure terminal echo round-trip latency using DSR (Device Status Report).
# Sends cursor-position queries and times the response. Useful for measuring
# latency over remote connections like Eternal Terminal (et), SSH, or mosh.
# Run locally first for a baseline, then over the remote connection to see
# the added overhead.
#
# Usage: latency.sh [count]   (default: 20 round-trips)

count=${1:-20}
echo "Measuring $count round-trips..."
latencies=()

for i in $(seq 1 "$count"); do
  start=$(date +%s%N)
  IFS='[;' read -p $'\e[6n' -d R -rs _ row col < /dev/tty
  end=$(date +%s%N)
  ms=$(( (end - start) / 1000000 ))
  latencies+=("$ms")
  echo "  #$i: ${ms} ms"
  sleep 0.1
done

IFS=$'\n' sorted=($(sort -n <<<"${latencies[*]}")); unset IFS
total=0
for l in "${latencies[@]}"; do total=$((total + l)); done
avg=$((total / count))
min=${sorted[0]}
max=${sorted[-1]}
p50=${sorted[$((count / 2))]}

echo ""
echo "Results: min=${min}ms  avg=${avg}ms  p50=${p50}ms  max=${max}ms"
