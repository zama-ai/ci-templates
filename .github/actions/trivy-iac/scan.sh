#!/usr/bin/env bash
# Scan IaC files with Trivy and the shared rules of checks/.
# The trivy-iac action runs this script. Run it locally from the repository root (needs Docker).
# Inputs are environment variables: SCAN_PATH, EXTRA_CHECKS, MISCONFIG_SCANNERS, EXIT_CODE.
set -euo pipefail

action_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRIVY_IMAGE="ghcr.io/aquasecurity/trivy:0.76.2@sha256:8f6bb947dbc528902e11f2f5be52f7b519f6a39d5d148f41166f2040499768fb"
WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
SHARED_CHECKS="${action_dir}/checks"
SCAN_PATH="${SCAN_PATH:-.}"
EXTRA_CHECKS="${EXTRA_CHECKS:-}"
MISCONFIG_SCANNERS="${MISCONFIG_SCANNERS:-}"
EXIT_CODE="${EXIT_CODE:-1}"

mounts=(-v "${WORKSPACE}:/repo:ro" -v "${SHARED_CHECKS}:/checks/shared:ro")
args=(--config-check /checks/shared)
if [ -n "$EXTRA_CHECKS" ]; then
  if [ ! -d "${WORKSPACE}/${EXTRA_CHECKS}" ]; then
    echo "extra-checks folder not found: ${EXTRA_CHECKS}" >&2
    exit 1
  fi
  mounts+=(-v "${WORKSPACE}/${EXTRA_CHECKS}:/checks/extra:ro")
  args+=(--config-check /checks/extra)
fi
if [ -n "$MISCONFIG_SCANNERS" ]; then
  args+=(--misconfig-scanners "$MISCONFIG_SCANNERS")
fi

log="$(mktemp)"
trap 'rm -f "$log"' EXIT
set +e
docker run --rm --network none -w /repo "${mounts[@]}" "$TRIVY_IMAGE" config \
  --skip-version-check --skip-check-update --exit-code "$EXIT_CODE" \
  --raw-config-scanners terraform --check-namespaces user \
  "${args[@]}" -- "$SCAN_PATH" 2>&1 | tee "$log"
status="${PIPESTATUS[0]}"
set -e
# Trivy runs offline, so it cannot load a remote module without a terraform init
if grep -q 'Failed to load module' "$log"; then
  echo "::error::A Terraform module did not load, so the scan is incomplete. Run 'terraform init -backend=false -input=false' in its Terraform root before trivy-iac. See the 'Failed to load module' lines above."
  exit 1
fi
exit "$status"
