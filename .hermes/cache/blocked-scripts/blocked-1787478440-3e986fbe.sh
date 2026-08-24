#!/bin/bash
# Auto-saved by Hermes: this command exceeded the inline command
# parser limit and was blocked from direct execution. Review it,
# then run it via: bash /data/.hermes/cache/blocked-scripts/blocked-1787478440-3e986fbe.sh
curl -s --max-time 10 https://wallet.basalam.com/ 2>/dev/null | grep -oP "src="[^"]+\.js""
