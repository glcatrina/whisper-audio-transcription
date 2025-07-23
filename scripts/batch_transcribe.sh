#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 <audio_directory> [model] [language] [output_format]"
    echo ""
    echo "Batch transcribe all audio files in a directory"
    echo ""
    echo "Supported formats: mp3, wav, m4a, flac, ogg, mp4, webm"
    exit 1
fi

AUDIO_DIR="$1"
MODEL="${2:-large-v3}"
LANGUAGE="$3"
OUTPUT_FORMAT="${4:-txt}"

if [ ! -d "$AUDIO_DIR" ]; then
    echo -e "${RED}❌ Directory not found: $AUDIO_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}🎤 Starting batch transcription...${NC}"
echo -e "${YELLOW}📁 Audio directory: $AUDIO_DIR${NC}"
echo -e "${YELLOW}🤖 Model: $MODEL${NC}"
echo -e "${YELLOW}🌍 Language: ${LANGUAGE:-Auto-detect}${NC}"
echo -e "${YELLOW}📄 Output format: $OUTPUT_FORMAT${NC}"
echo ""

# Count total files
TOTAL_FILES=$(find "$AUDIO_DIR" -type f \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.flac" -o -iname "*.ogg" -o -iname "*.mp4" -o -iname "*.webm" \) | wc -l)

if [ $TOTAL_FILES -eq 0 ]; then
    echo -e "${RED}❌ No audio files found in directory${NC}"
    exit 1
fi

echo -e "${GREEN}Found $TOTAL_FILES audio files${NC}"
echo ""

CURRENT=0
# Process each audio file
find "$AUDIO_DIR" -type f \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.flac" -o -iname "*.ogg" -o -iname "*.mp4" -o -iname "*.webm" \) | while read -r file; do
    CURRENT=$((CURRENT + 1))
    echo -e "${YELLOW}[$CURRENT/$TOTAL_FILES] Processing: $(basename "$file")${NC}"
    
    if [ ! -z "$LANGUAGE" ]; then
        ./scripts/transcribe.sh "$file" "$MODEL" "$LANGUAGE" "$OUTPUT_FORMAT"
    else
        ./scripts/transcribe.sh "$file" "$MODEL" "" "$OUTPUT_FORMAT"
    fi
    
    echo ""
done

echo -e "${GREEN}✅ Batch transcription completed!${NC}"
