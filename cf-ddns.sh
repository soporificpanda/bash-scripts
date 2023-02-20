#!/bin/bash

ZONE_ID='zone id'
TOKEN='api token'
RECORD_NAME='example.com'

#IPV4
PUBLIC_IPv4=$(curl -s 'ipv4.icanhazip.com')
CURRENT_RECORDv4=$(dig @1.1.1.1 +short $RECORD_NAME)
RECORD_TYPEv4='A'
RECORD_IDv4=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$RECORD_NAME" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" | grep -o '"id":"[^"]*' | cut -d'"' -f4)

#IPV6
PUBLIC_IP=$(curl -s icanhazip.com)
CURRENT_RECORD=$(dig @1.1.1.1 AAAA +short $RECORD_NAME)
RECORD_TYPE='AAAA'
RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=AAAA&name=$RECORD_NAME" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json"  | grep -o '"id":"[^"]*' | cut -d'"' -f4)

DATA_JSON="{\"type\":\"$RECORD_TYPE\",\"name\":\"$RECORD_NAME\",\"content\":\"$PUBLIC_IP\"}"


if [[ $CURRENT_RECORD = $PUBLIC_IP ]]
then
        echo "IPv6 is OK"
else
        curl --request PUT \
          --url https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID \
          --header 'Content-Type: application/json' \
          --header "Authorization: Bearer $TOKEN" \
          --data $DATA_JSON
fi

DATA_JSONv4="{\"type\":\"$RECORD_TYPEv4\",\"name\":\"$RECORD_NAME\",\"content\":\"$PUBLIC_IPv4\"}"

if [[ $CURRENT_RECORDv4 = $PUBLIC_IPv4 ]]
then
        echo "IPv4 is OK"
else
        curl --request PUT \
          --url https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_IDv4 \
          --header 'Content-Type: application/json' \
          --header "Authorization: Bearer $TOKEN" \
          --data $DATA_JSONv4
fi
