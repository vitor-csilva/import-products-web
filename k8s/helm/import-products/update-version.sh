#!/bin/bash

# path to Chart.yaml
CHART_FILE="Chart.yaml"
DOCKERFILE="Dockerfile"

# Verifica se o Chart.yaml existe
if [[ ! -f "$CHART_FILE" ]]; then
  echo "❌ file $CHART_FILE not find."
  exit 1
fi

TAG=$(grep '^version:' "$CHART_FILE" | awk '{ print $2 }')

if [[ -z "$TAG" ]]; then
  echo "❌ Version not found for $CHART_FILE"
  exit 1
fi

echo "✅ Version found: $TAG"

# Substitui o valor da TAG no Dockerfile
# Exemplo: de ARG TAG=1.0.0 -> ARG TAG=1.2.3
sed -i -E "s/^(ARG TAG=).*/\1$TAG/" "$DOCKERFILE"

echo "✅ Dockerfile updated with TAG=$TAG"
