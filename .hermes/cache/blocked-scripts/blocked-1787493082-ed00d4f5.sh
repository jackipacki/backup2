#!/bin/bash
# Auto-saved by Hermes: this command exceeded the inline command
# parser limit and was blocked from direct execution. Review it,
# then run it via: bash /data/.hermes/cache/blocked-scripts/blocked-1787493082-ed00d4f5.sh
grep -oP 'https?://[^"'\s]+' /tmp/main.js 2>/dev/null | sort -u | head -40
