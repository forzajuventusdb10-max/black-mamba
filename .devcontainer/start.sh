#!/bin/bash
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

if [ -f /etc/config.json ] && [ -f /app/uuid.txt ] && [ -f /app/selected_ip.txt ]; then
    echo -e "${GREEN}✅ Already configured. Starting Xray...${NC}"
    /usr/local/bin/xray -c /etc/config.json > /tmp/xray.log 2>&1 &
    sleep 2
    /app/verify.sh
    tail -f /tmp/xray.log
    exit 0
fi

echo ""
echo "========================================="
echo "🌐 GH TUN SETUP (Auto mode for Codespaces)"
echo "========================================="
echo ""

# Default server (Germany)
SELECTED_IP="94.130.50.12"
SELECTED_NAME="Germany"
echo -e "${GREEN}✓ Auto-selected: ${SELECTED_NAME} (${SELECTED_IP})${NC}"

UUID=$(cat /proc/sys/kernel/random/uuid)
echo "$UUID" > /app/uuid.txt
echo "$SELECTED_IP" > /app/selected_ip.txt

sed -e "s/__UUID__/${UUID}/g" /etc/config.json.template > /etc/config.json

echo ""
echo "📝 Validating configuration..."
if /usr/local/bin/xray -test -c /etc/config.json 2>/dev/null; then
    echo -e "${GREEN}✅ Config valid${NC}"
else
    echo -e "${RED}❌ Config invalid${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Configuration generated${NC}"
echo -e "${BLUE}✓ UUID: ${UUID}${NC}"

echo ""
echo "🚀 Starting Xray..."
/usr/local/bin/xray -c /etc/config.json > /tmp/xray.log 2>&1 &
sleep 2

/app/verify.sh

echo ""
echo -e "${GREEN}✅ Ready! Copy the connection string above${NC}"
echo "========================================="

tail -f /tmp/xray.log