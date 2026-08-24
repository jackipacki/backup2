#!/bin/bash
# Auto-saved by Hermes: this command exceeded the inline command
# parser limit and was blocked from direct execution. Review it,
# then run it via: bash /data/.hermes/cache/blocked-scripts/blocked-1787478415-ef6dc8c5.sh
curl -s --max-time 10 https://basalam.com/ 2>/dev/null | grep -oP "src="[^"]+"" | head -20
