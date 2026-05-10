FROM debian:bookworm-slim

COPY config.json /etc/config.json
COPY start.sh verify.sh /app/
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O xray.zip https://github.com/XTLS/Xray-core/releases/download/v26.3.27/Xray-linux-64.zip && \
    unzip -q xray.zip && chmod +x xray && mv xray /usr/local/bin/xray && rm -f xray.zip

RUN chmod +x /app/start.sh /app/verify.sh

RUN echo 'alias xray-status="/app/verify.sh"' >> /etc/bash.bashrc && \
    echo 'alias xray-restart="pkill xray && /usr/local/bin/xray -c /etc/config.json > /tmp/xray.log 2>&1 &"' >> /etc/bash.bashrc && \

CMD ["/app/start.sh"]