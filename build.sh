#!/usr/bin/env bash

set -euo pipefail

ARCHITECTURE="arm64"
SUITE="bookworm"
IMAGE="droidian-kali-phosh.img"
VERBOSE=false

show_usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
    -a, --architecture ARCH    Set architecture (default: arm64)
    -s, --suite SUITE          Set Debian suite (default: bookworm)
    -i, --image IMAGE          Set output image name (default: droidian-kali-phosh.img)
    -v, --verbose              Enable verbose output
    -h, --help                 Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -a|--architecture|-s|--suite|-i|--image)
            if [[ $# -lt 2 ]]; then
                show_usage >&2
                exit 2
            fi
            case "$1" in
                -a|--architecture) ARCHITECTURE="$2" ;;
                -s|--suite) SUITE="$2" ;;
                -i|--image) IMAGE="$2" ;;
            esac
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            show_usage >&2
            exit 2
            ;;
    esac
done

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)." >&2
    exit 1
fi

if ! command -v debos >/dev/null 2>&1; then
    echo "debos is not installed. Install it with: apt install debos" >&2
    exit 1
fi

mkdir -p artifacts logs
LOG_FILE="logs/build-$(date +%Y%m%d-%H%M%S).log"
DEBOS_ARGS=(
    --artifactdir artifacts
    --template-var "architecture:$ARCHITECTURE"
    --template-var "suite:$SUITE"
    --template-var "image:$IMAGE"
)

echo "Building $IMAGE for $ARCHITECTURE ($SUITE). Log: $LOG_FILE"
if [[ $VERBOSE == true ]]; then
    DEBOS_ARGS=(-v "${DEBOS_ARGS[@]}")
fi

if debos "${DEBOS_ARGS[@]}" droidian-kali-phosh.yaml 2>&1 | tee "$LOG_FILE"; then
    OUTPUT_IMAGE="artifacts/$IMAGE"
    if [[ ! -f $OUTPUT_IMAGE ]]; then
        echo "Build completed but image was not found: $OUTPUT_IMAGE" >&2
        exit 1
    fi
    echo "Build completed successfully: $OUTPUT_IMAGE"
else
    status=$?
    echo "Build failed. Last 20 lines of $LOG_FILE:" >&2
    tail -n 20 "$LOG_FILE" >&2
    exit "$status"
fi
