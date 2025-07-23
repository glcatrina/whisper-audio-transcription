# Troubleshooting Guide

## Common Issues and Solutions

### Installation Issues

#### "Package not found" errors
```bash
sudo apt update && sudo apt upgrade -y
```

#### Python version conflicts
Ensure you're using Python 3.8 or later:
```bash
python3 --version
```

#### Virtual environment issues
Remove and recreate:
```bash
rm -rf whisper-env
python3 -m venv whisper-env
source whisper-env/bin/activate
pip install -r requirements.txt
```

### Runtime Issues

#### "FP16 is not supported on CPU"
This warning is normal for CPU-only systems and can be ignored.

#### Out of memory errors
- Use smaller models: `--model small` or `--model base`
- Close other applications
- Monitor memory usage: `htop`

#### Slow processing
- First run downloads models (several GB)
- Use smaller models for faster processing
- Consider closing other applications

### Audio Issues

#### Unsupported audio format
Convert using ffmpeg:
```bash
ffmpeg -i input.format output.wav
```

#### Poor transcription quality
- Try larger models: `--model large-v3`
- Specify language manually: `--language English`
- Improve audio quality (reduce noise, increase volume)
- Use initial prompt for context

### Language Issues

#### Wrong language detected
Specify manually:
```bash
whisper audio.mp3 --language Romanian
```

#### Missing language support
Whisper supports 99+ languages. Check spelling:
```bash
whisper --help | grep -A 200 "language"
```

## Getting More Help

1. Check system requirements
2. Verify installation with `whisper --help`
3. Test with sample audio file
4. Check [GitHub issues](https://github.com/glcatrina/whisper-audio-transcription/issues)
