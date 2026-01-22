#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Formatting Terraform files..."
terraform fmt -recursive

echo "==> Validating Terraform modules..."
for dir in modules/*/; do
  echo "    Validating $dir"
  terraform -chdir="$dir" init -backend=false -input=false > /dev/null 2>&1
  terraform -chdir="$dir" validate
done

echo "==> Running tflint..."
if command -v tflint &> /dev/null; then
  for dir in modules/*/; do
    echo "    Linting $dir"
    tflint --chdir="$dir"
  done
else
  echo "    tflint not installed, skipping"
fi

echo "==> All checks passed"
