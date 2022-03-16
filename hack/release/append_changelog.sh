#!/usr/bin/env bash

set -e

CHANGELOG=$(cat toCopy/CHANGELOG.md)
BASE_FILE=$(cat docs/release/release-template.md)

echo "${BASE_FILE}" > toCopy/CHANGELOG.md
echo "${CHANGELOG}" >> toCopy/CHANGELOG.md