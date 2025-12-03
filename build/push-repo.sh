#!/usr/bin/env bash
set -euo pipefail

# Ensure that "KIT_GITHUB_ACCESS" environment variable is set
if [ -z "${KIT_GITHUB_ACCESS:-}" ]; then
  echo "Error: KIT_GITHUB_ACCESS environment variable is not set." >&2
  exit 1
fi

REPO_OWNER="KvalitetsIT"
REPO_NAME="helm-repo"
REPO_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}.git"

mkdir -p helm
cd helm

git clone "$REPO_URL"
cd "$REPO_NAME"
git config user.name "Github Actions"
git config user.email "development@kvalitetsit.dk"

mkdir -p argoApps
cp ../../argoApps-*.tgz argoApps || true
helm repo index . --url https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/master/

git add -A
if git diff --cached --quiet; then
  echo "No changes to commit. Skipping push."
  exit 0
fi

git commit -m "Adding new argoApps chart"

echo "Pushing changes to ${REPO_OWNER}/${REPO_NAME}..."
git -c http.extraHeader="Authorization: Bearer ${KIT_GITHUB_ACCESS}" push "$REPO_URL"

echo "Push complete."
