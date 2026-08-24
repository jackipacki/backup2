#!/bin/bash
# Auto-saved by Hermes: this command exceeded the inline command
# parser limit and was blocked from direct execution. Review it,
# then run it via: bash /data/.hermes/cache/blocked-scripts/blocked-1787478477-960f2d15.sh
curl -s --max-time 10 https://basalam.com/ 2>/dev/null | grep -oP "(src|href)="(/charsou[^"]+)"" | sort -u | head -30
