#!/bin/sh
set -eu
code=$(curl -sS -o /dev/null -w '%{http_code}' -X POST \
  http://lakekeeper:8181/management/v1/bootstrap \
  -H 'Content-Type: application/json' \
  --data '{"accept-terms-of-use":true}')
case "$code" in
  2??|400) exit 0 ;;
  *) echo "Lakekeeper bootstrap returned HTTP $code" >&2; exit 1 ;;
esac
