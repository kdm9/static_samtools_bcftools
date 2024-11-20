#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LIBEXEC="$(dirname -- "$SCRIPT_DIR")/libexec/bcftools"
export BCFTOOLS_PLUGINS="$LIBEXEC"
"${LIBEXEC}/bcftools" "${@}"
