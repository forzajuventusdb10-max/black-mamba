FROM debian:bookworm-slim

COPY config.json.template /etc/config.json.template
COPY start.sh verify.sh /app/
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN echo "📦 Installing Xray..." && \
    wget -q -O xray.zip https://github.com/XTLS/Xray-core/releases/download/v26.3.27/Xray-linux-64.zip && \
    unzip -q xray.zip && \
    chmod +x xray && \
    mv xray /usr/local/bin/xray && \
    rm -f xray.zip && \
    echo "✅ Xray installed"

RUN chmod +x /app/start.sh /app/verify.sh

RUN echo 'alias xray-status="/app/verify.sh"' >> /etc/bash.bashrc && \
    echo 'alias xray-restart="pkill xray && /usr/local/bin/xray -c /etc/config.json > /tmp/xray.log 2>&1 & && echo \"✅ Xray restarted\""' >> /etc/bash.bashrc && \
    echo 'alias xray-link="if [ -f /app/uuid.txt ] && [ -f /app/selected_ip.txt ]; then echo \"vless://$(cat /app/uuid.txt)@$(cat /app/selected_ip.txt):443?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=${CODESPACE_NAME}-443.app.github.dev&path=%2F#GH-Tun\"; else echo \"❌ Not configured yet\"; fi"' >> /etc/bash.bashrc

RUN cat > /etc/logrotate.d/xray <<'EOF'
/tmp/xray.log /tmp/xray_error.log {
    daily; rotate 3; size 10M; compress; delaycompress; missingok; notifempty; create 644 root root
}
EOF

CMD ["/app/start.sh"]