#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
ARCHITECTURE="arm64"
SUITE="bookworm"
IMAGE="droidian-kali-phosh.img"
VERBOSE=false

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -a, --architecture ARCH    Set architecture (default: arm64)
    -s, --suite SUITE          Set Debian suite (default: bookworm)
    -i, --image IMAGE          Set output image name (default: droidian-kali-phosh.img)
    -v, --verbose              Enable verbose output
    -h, --help                 Show this help message

Examples:
    $0                                          # Build with defaults
    $0 -a armhf -s bullseye                   # Build for armhf with bullseye
    $0 -i my-custom-image.img -v              # Custom image name with verbose output
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -a|--architecture)
            ARCHITECTURE="$2"
            shift 2
            ;;
        -s|--suite)
            SUITE="$2"
            shift 2
            ;;
        -i|--image)
            IMAGE="$2"
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
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run as root (use sudo)"
    exit 1
fi

# Check if debos is installed
if ! command -v debos &> /dev/null; then
    print_error "debos is not installed. Please install it with: apt install debos"
    exit 1
fi

# Check available disk space (need at least 10GB)
AVAILABLE_SPACE=$(df . | tail -1 | awk '{print $4}')
REQUIRED_SPACE=10485760  # 10GB in KB

if [[ $AVAILABLE_SPACE -lt $REQUIRED_SPACE ]]; then
    print_warning "Available disk space is less than 10GB. Build may fail."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create logs directory
mkdir -p logs

# Prepare debos command
DEBOS_CMD="debos"
if [[ $VERBOSE == true ]]; then
    DEBOS_CMD="$DEBOS_CMD -v"
fi

DEBOS_CMD="$DEBOS_CMD -t architecture:$ARCHITECTURE -t suite:$SUITE -t image:$IMAGE"

# Show build configuration
print_status "Starting Droidian Kali Phosh build..."
print_status "Configuration:"
echo "  Architecture: $ARCHITECTURE"
echo "  Suite: $SUITE"
echo "  Image: $IMAGE"
echo "  Verbose: $VERBOSE"
echo

# Run the build
LOG_FILE="logs/build-$(date +%Y%m%d-%H%M%S).log"
print_status "Build output will be logged to: $LOG_FILE"

if $VERBOSE; then
    $DEBOS_CMD droidian-kali-phosh.yaml 2>&1 | tee "$LOG_FILE"
else
    print_status "Building... (this may take 30-60 minutes)"
    if $DEBOS_CMD droidian-kali-phosh.yaml > "$LOG_FILE" 2>&1; then
        print_status "Build completed successfully!"
    else
        print_error "Build failed. Check $LOG_FILE for details."
        echo "Last 20 lines of log:"
        tail -20 "$LOG_FILE"
        exit 1
    fi
fi

# Check if image was created
if [[ -f "$IMAGE" ]]; then
    IMAGE_SIZE=$(du -h "$IMAGE" | cut -f1)
    print_status "Image created successfully: $IMAGE ($IMAGE_SIZE)"
    print_status "You can now flash this image to your device"
else
    print_error "Image file not found: $IMAGE"
    exit 1
fi

print_status "Build process completed!"

    
    if [ "$VERBOSE" = true ]; then
        debos_args+=("--verbose")
    fi
    
    debos_args+=(
        "--artifactdir=artifacts"
        "--template-var=architecture:$ARCHITECTURE"
        "--template-var=suite:$SUITE"
        "--template-var=imagesize:$IMAGE_SIZE"
        "--template-var=image:$OUTPUT_IMAGE"
        "droidian-kali-phosh.yaml"
    )
    
    log "Running debos with arguments: ${debos_args[*]}"
    
    if ! debos "${debos_args[@]}"; then
        error "debos build failed"
    fi
    
    success "Image built successfully: artifacts/$OUTPUT_IMAGE"
}

# Create artifacts directory
mkdir -p artifacts

# Run build steps
check_dependencies
validate_environment
build_image

log "Build completed successfully!"
log "You can find your image at: artifacts/$OUTPUT_IMAGE"
log ""
log "To flash the image to a device:"
log "  sudo dd if=artifacts/$OUTPUT_IMAGE of=/dev/sdX bs=4M status=progress"
log "  (Replace /dev/sdX with your actual device)"