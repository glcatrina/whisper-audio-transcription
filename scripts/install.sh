#!/bin/bash

set -e

echo "🚀 Installing Whisper Audio Transcription Setup"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on Ubuntu
if ! command -v lsb_release &> /dev/null; then
    echo -e "${RED}❌ This script requires Ubuntu. lsb_release not found.${NC}"
    exit 1
fi

DISTRIB_ID=$(lsb_release -si)
if [ "$DISTRIB_ID" != "Ubuntu" ]; then
    echo -e "${RED}❌ This script is designed for Ubuntu systems only.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Ubuntu detected: $(lsb_release -sd)${NC}"

# Check Python version
if ! python3 -c "import sys; exit(0 if sys.version_info >= (3, 8) else 1)"; then
    echo -e "${RED}❌ Python 3.8+ required. Found: $(python3 --version)${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Python version: $(python3 --version)${NC}"

# Update system
echo -e "${YELLOW}📦 Updating system packages...${NC}"
sudo apt update -qq

# Install system dependencies
echo -e "${YELLOW}📦 Installing system dependencies...${NC}"
sudo apt install -y python3 python3-pip python3-venv ffmpeg git

# Create virtual environment
echo -e "${YELLOW}🐍 Creating Python virtual environment...${NC}"
python3 -m venv whisper-env

# Activate virtual environment
source whisper-env/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install Whisper and dependencies
echo -e "${YELLOW}🎤 Installing OpenAI Whisper...${NC}"
pip install -r requirements.txt

# Create directories
mkdir -p {transcriptions,examples/audio,examples/transcriptions}

# Make scripts executable
chmod +x scripts/*.sh

# Verify installation
echo -e "${YELLOW}🧪 Verifying installation...${NC}"
if whisper --help > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Whisper installed successfully!${NC}"
else
    echo -e "${RED}❌ Whisper installation failed!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
echo ""
echo "To get started:"
echo "1. Activate the environment: source whisper-env/bin/activate"
echo "2. Test with sample audio: ./scripts/transcribe.sh examples/audio/sample.wav"
echo "3. Or transcribe your own: ./scripts/transcribe.sh path/to/your/audio.mp3"
echo ""
