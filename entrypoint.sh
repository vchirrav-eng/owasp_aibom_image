#!/bin/sh
set -eu

if [ -d "/data" ] && [ -w "/data" ]; then
  CACHE_ROOT="/data/.cache/huggingface"
  OUTPUT_ROOT="/data/aibom_output"
else
  CACHE_ROOT="/tmp/.cache/huggingface"
  OUTPUT_ROOT="/tmp/aibom_output"
fi

mkdir -p "${CACHE_ROOT}" "${OUTPUT_ROOT}"

export HF_HOME="${HF_HOME:-${CACHE_ROOT}}"
export TRANSFORMERS_CACHE="${TRANSFORMERS_CACHE:-${CACHE_ROOT}/transformers}"
export AIBOM_OUTPUT_DIR="${AIBOM_OUTPUT_DIR:-${OUTPUT_ROOT}}"
export PORT="${PORT:-7860}"

mkdir -p "${TRANSFORMERS_CACHE}" "${AIBOM_OUTPUT_DIR}"

if [ "$#" -gt 0 ]; then
  exec python -m src.cli "$@"
fi

exec uvicorn src.main:app --host 0.0.0.0 --port "${PORT}"
