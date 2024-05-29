#!/bin/bash
# Função para carregar o .env manualmente
load_env() {
  export $(grep -v '^#' .env | xargs)
}

# Carregar variáveis do arquivo .env
load_env

# Gerar um UUID aleatório para apns-id
APNS_ID=$(uuidgen)

# Obter o timestamp atual
JWT_ISSUED_AT=$(date +%s)

# Criar os componentes do JWT
JWT_HEADER=$(printf '{"alg":"ES256","kid":"%s"}' "$AUTH_KEY_ID" | base64 | tr -d '=' | tr '/+' '_-')
JWT_CLAIM=$(printf '{"iss":"%s","iat":%d}' "$TEAM_ID" "$JWT_ISSUED_AT" | base64 | tr -d '=' | tr '/+' '_-')
JWT_SIGNATURE=$(printf '%s.%s' "$JWT_HEADER" "$JWT_CLAIM" | openssl dgst -sha256 -sign "$AUTH_KEY_PATH" | base64 | tr -d '=' | tr '/+' '_-')

# Combinar os componentes do JWT
JWT=$(printf '%s.%s.%s' "$JWT_HEADER" "$JWT_CLAIM" "$JWT_SIGNATURE")
# PUSH_TYPE=voip
# -H "apns-push-type: voip" \
# URL do APNs
APNS_URL="https://api.sandbox.push.apple.com/3/device/$DEVICE_TOKEN"

# Enviar a notificação
curl -v \
-d @notification.json \
--http2 \
-H "apns-topic: $BUNDLE_ID" \
-H "apns-push-type: $PUSH_TYPE" \
-H "authorization: bearer $JWT" \
-H "apns-id: $APNS_ID" \
$APNS_URL