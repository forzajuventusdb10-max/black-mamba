#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
echo ""
echo "========================================="
echo "🔍 XRAY VERIFICATION"
echo "========================================="

echo ""
echo "📝 CONFIGURATION CHECK:"
if /usr/local/bin/xray -test -c /etc/config.json 2>/dev/null; then
    echo -e "${GREEN}✅ Config syntax valid${NC}"
else
    echo -e "${RED}❌ Config syntax invalid${NC}"
fi

UUID=$(cat /app/uuid.txt 2>/dev/null || echo "NOT_SET")
SELECTED_IP=$(cat /app/selected_ip.txt 2>/dev/null || echo "NOT_SET")

if [ "$UUID" != "NOT_SET" ] && [ "$SELECTED_IP" != "NOT_SET" ]; then
    echo ""
    echo -e "${BLUE}📋 Active Server: ${SELECTED_IP}${NC}"
    echo -e "${BLUE}🔑 UUID: ${UUID:0:8}...${UUID: -8}${NC}"
fi

echo ""
echo "🔍 SERVICE STATUS:"
if pgrep -x xray > /dev/null; then
    echo -e "${GREEN}✅ Xray is running (PID: $(pgrep -x xray))${NC}"
else
    echo -e "${RED}❌ Xray is NOT running${NC}"
fi

echo ""
echo "📡 PORT STATUS:"
if ss -tlnp 2>/dev/null | grep -q ":443"; then
    echo -e "${GREEN}✅ Port 443 is listening${NC}"
else
    echo -e "${RED}❌ Port 443 is NOT listening${NC}"
fi

echo ""
echo "📋 LOG STATUS:"
if [ -f /tmp/xray.log ]; then
    LOG_SIZE=$(du -h /tmp/xray.log | cut -f1)
    echo -e "${GREEN}✅ Main log: /tmp/xray.log (${LOG_SIZE})${NC}"
fi
if [ -f /tmp/xray_error.log ] && [ -s /tmp/xray_error.log ]; then
    echo -e "${YELLOW}⚠️  Errors detected in /tmp/xray_error.log${NC}"
    echo -e "${YELLOW}Last 3 errors:${NC}"
    tail -3 /tmp/xray_error.log | while read line; do echo "  $line"; done
fi

if [ -n "$CODESPACE_NAME" ] && [ -f /app/uuid.txt ] && [ -f /app/selected_ip.txt ]; then
    UUID=$(cat /app/uuid.txt)
    SELECTED_IP=$(cat /app/selected_ip.txt)
    echo ""
    echo "========================================="
    echo "🔗 CURRENT VLESS CONNECTION STRING"
    echo "========================================="
    echo -e "${GREEN}vless://${UUID}@${SELECTED_IP}:443?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=${CODESPACE_NAME}-443.app.github.dev&path=%2F#GH-Tun${NC}"
    echo "========================================="
fi

if [ -n "$CODESPACE_NAME" ]; then
    echo ""
    echo "🌐 PUBLIC ACCESS URL:"
    echo -e "${GREEN}https://${CODESPACE_NAME}-443.app.github.dev${NC}"
fi
echo ""