#!/bin/bash
set -e

GREEN='\033[0;32m'; NC='\033[0m'

FIXED_UUID="550e8400-e29b-41d4-a716-446655440000"
FIXED_IP="94.130.50.12"

if [ ! -f /etc/config.json ]; then
    echo "🔧 Generating config with UUID: $FIXED_UUID"
    sed -e "s/__UUID__/${FIXED_UUID}/g" /etc/config.json.template > /etc/config.json
fi

echo -e "${GREEN}🚀 Starting Xray...${NC}"
/usr/local/bin/xray -c /etc/config.json > /tmp/xray.log 2>&1 &
sleep 2

exec tail -f /tmp/xray.log