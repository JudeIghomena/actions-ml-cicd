#!/bin/bash
set -e

# Activate MLflow and register model
echo "Registering model: $MODEL_NAME at $MLFLOW_TRACKING_URI"

# Upload model
mlflow models serve -m "$MODEL_PATH"

# Register model version
VERSION=$(mlflow models register -m "$MODEL_PATH" --name "$MODEL_NAME" | grep 'Version' | awk '{print $2}')

echo "Model registered with version: $VERSION"

# Transition model to desired stage
if [ -n "$STAGE" ]; then
  mlflow models transition -n "$MODEL_NAME" -v "$VERSION" -s "$STAGE"
  echo "Model transitioned to $STAGE"
fi
