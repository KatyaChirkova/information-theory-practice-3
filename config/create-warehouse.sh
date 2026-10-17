#!/bin/sh
set -eu
if curl -fsS http://lakekeeper:8181/management/v1/warehouse | grep -q '"name":"demo"'; then
  exit 0
fi
code=$(curl -sS -o /dev/null -w '%{http_code}' -X POST \
  http://lakekeeper:8181/management/v1/warehouse \
  -H 'Content-Type: application/json' \
  --data-binary @/config/create-warehouse.json)
case "$code" in
  2??) exit 0 ;;
  *) echo "Lakekeeper warehouse creation returned HTTP $code" >&2; exit 1 ;;
esac
