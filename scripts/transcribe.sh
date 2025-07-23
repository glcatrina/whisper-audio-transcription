#!/bin/bash

set -e

# Default values
MODEL="large-v3"
LANGUAGE=""
OUTPUT_DIR="./transcriptions"
OUTPUT_FORMAT="txt"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Help function
show_help() {
    echo "Usage: $0 <audio_file> [model] [language] [output_format]"
    echo ""
    echo "Arguments:"
    echo "  audio_file     Path to audio file (required)"
    echo "  model          Whisper model (default: large-v3)"
    echo "                 Options: tiny, base, small, medium, large-v3"
    echo "  language       Audio language (default: auto-detect)"
    echo "                 Examples: English, Spanish, French, Romanian"
    echo "  output_format  Output format (default: txt)"
    echo "                 Options: txt, srt, vtt, json, tsv"
    echo ""
    echo "Examples:"
    echo "  $0 audio.mp3"
    echo "  $0 audio.mp3 medium English"
    echo "  $0 audio.mp3 large-v3 Romanian srt"
    exit 1
}

# Check arguments
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
fi

AUDIO_FILE="$1"
[ ! -z "$2" ] && MODEL="$2"
[ ! -z "$3" ] && LANGUAGE="$3"
[ ! -z "$4" ] && OUTPUT_FORMAT="$4"

# Check if audio file exists
if [ ! -f "$AUDIO_FILE" ]; then
    echo -e "${RED}❌ Audio file not found: $AUDIO_FILE${NC}"
    exit 1
fi

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${YELLOW}⚠️  Virtual environment not activated. Activating now...${NC}"
    if [ -f "whisper-env/bin/activate" ]; then
        source whisper-env/bin/activate
    else
        echo -e "${RED}❌ Virtual environment not found. Run install.sh first.${NC}"
        exit 1
    fi
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Build whisper command
WHISPER_CMD="whisper \"$AUDIO_FILE\" --model $MODEL --output_format $OUTPUT_FORMAT --output_dir $OUTPUT_DIR"

if [ ! -z "$LANGUAGE" ]; then
    WHISPER_CMD="$WHISPER_CMD --language $LANGUAGE"
fi

echo -e "${GREEN}🎤 Starting transcription...${NC}"
echo -e "${YELLOW}📁 Audio file: $AUDIO_FILE${NC}"
echo -e "${YELLOW}🤖 Model: $MODEL${NC}"
echo -e "${YELLOW}🌍 Language: ${LANGUAGE:-Auto-detect}${NC}"
echo -e "${YELLOW}📄 Output format: $OUTPUT_FORMAT${NC}"
echo -e "${YELLOW}📂 Output directory: $OUTPUT_DIR${NC}"
echo ""

# Run transcription
eval $WHISPER_CMD

echo ""
echo -e "${GREEN}✅ Transcription completed!${NC}"
echo -e "${GREEN}📁 Check the output in: $OUTPUT_DIR${NC}"
