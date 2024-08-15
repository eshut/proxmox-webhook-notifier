#!/bin/bash

# Webhook URL
WEBHOOK_URL_TEST="https://yawdev.app.n8n.cloud/webhook-test...."
WEBHOOK_URL="https://yawdev.app.n8n.cloud/webhook/....."

# Fetch internal IP address
INTERNAL_IP=$(hostname -I | awk '{print $1}')

# Fetch public IP address using an external service
PUBLIC_IP=$(curl -s ifconfig.me)

echo "$INTERNAL_IP"
echo "$PUBLIC_IP"

NODE=$(hostname)

if [ "$NODE" == "yawdev-server" ]; then
  NODE="$NODE | datacenter"
fi

DATA=$(cat <<EOF
{
  "event": "Power ON",
  "node": "$NODE",
  "internal_ip": "$INTERNAL_IP",
  "public_ip": "$PUBLIC_IP",
  "timestamp": "$(date -u +"%d.%m.%y %H:%M:%S")"
}
EOF
)

# Send data to the webhook
curl -X POST -H "Content-Type: application/json" -d "$DATA" "$WEBHOOK_URL"
