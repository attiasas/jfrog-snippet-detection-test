#!/usr/bin/env bash
# Reproducible local/CI snippet benchmark via JFrog CLI.
# Prerequisites: jf CLI 2.104.1 (CI-pinned), Unified Security + Catalog on your JPD.
# Docs: https://docs.jfrog.com/security/docs/run-snippet-detection

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

WATCHES="${JF_SNIPPET_WATCHES:-}"
if [[ -z "$WATCHES" ]]; then
  WATCHES="minimum-to-respect"
fi
PROJECT="${JF_PROJECT:-}"

if ! command -v jf >/dev/null 2>&1; then
  echo "error: jf CLI not found. Install from https://docs.jfrog.com/docs/cli" >&2
  exit 1
fi

ARGS=(audit --sca --sbom --static-sca --snippet)

if [[ -n "$PROJECT" ]]; then
  ARGS+=(--project="$PROJECT")
else
  ARGS+=(--watches="$WATCHES")
fi

echo "Running: jf ${ARGS[*]}"
jf "${ARGS[@]}"

echo ""
echo "Expected ground truth: benchmark/expected-findings.yaml"
echo "Compare License Compliance Violations + SBOM snippet rows against that file."
