#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="production"
INTERVAL_SECONDS="${1:-0.3}"

FRONTEND_IP=$(kubectl get service frontend -n "${NAMESPACE}" \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "${FRONTEND_IP}" ]; then
  echo "Frontend LoadBalancer has no external IP yet." >&2
  exit 1
fi

URL="http://${FRONTEND_IP}/api/enrollments/health"
echo "Sending GET ${URL} every ${INTERVAL_SECONDS}s. Ctrl+C to stop."

while true; do
  CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "${URL}" || echo "000")
  echo "$(date +%H:%M:%S) ${CODE}"
  sleep "${INTERVAL_SECONDS}"
done
