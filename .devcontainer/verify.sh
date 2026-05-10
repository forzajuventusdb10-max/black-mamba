#!/bin/bash

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

echo ""
echo "========================================="
echo "🔍 XRAY VERIFICATION"
echo "========================================="

echo -e "\n📝 CONFIGURATION CHECK:"
if /usr/local/bin/xray -test -c /etc/config.json 2>/dev/null; then
    echo -e "${GREEN}✅ Config syntax valid${NC}"
else
    echo -e "${RED}❌ Config invalid${NC}"
fi

echo -e "\n🔍 SERVICE STATUS:"
if pgrep -x xray > /dev/null; then
    echo -e "${GREEN}✅ Xray is running (PID: $(pgrep -x xray))${NC}"
else
    echo -e "${RED}❌ Xray is NOT running${NC}"
fi

echo -e "\n📡 PORT STATUS:"
if ss -tlnp 2>/dev/null | grep -q ":443"; then
    echo -e "${GREEN}✅ Port 443 listening${NC}"
else
    echo -e "${RED}❌ Port 443 NOT listening${NC}"
fi

echo -e "\n📋 LOG STATUS:"
if [ -f /tmp/xray.log ]; then
    echo -e "${GREEN}✅ Log: /tmp/xray.log ($(du -h /tmp/xray.log | cut -f1))${NC}"
fi
if [ -f /tmp/xray_error.log ] && [ -s /tmp/xray_error.log ]; then
    echo -e "${YELLOW}⚠️ Errors in /tmp/xray_error.log:${NC}"
    tail -3 /tmp/xray_error.log
fi

if [ -n "$CODESPACE_NAME" ]; then
    echo ""
    echo "========================================="
    echo "🔗 VLESS CONNECTION STRING EXAMPLE (fixed UUID)"
    echo "========================================="
    echo -e "${GREEN}vless://550e8400-e29b-41d4-a716-446655440000@94.130.50.12:443?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=${CODESPACE_NAME}-443.app.github.dev&path=%2F#GH-Tun${NC}"
    echo "========================================="
    echo -e "🌐 PUBLIC URL: ${GREEN}https://${CODESPACE_NAME}-443.app.github.dev${NC}"
fi
echo ""