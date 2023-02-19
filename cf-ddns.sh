#!/bin/bash

ZONE_ID='zone id'
TOKEN='api token'

RECORD_ID='dns record id'
RECORD_NAME='example.com'

#IPV4
#PUBLIC_IP=$(curl -s 'ipv4.icanhazip.com')
#CURRENT_RECORD=$(dig @1.1.1.1 +short $RECORD_NAME)
#RECORD_TYPE='A'

#IPV6
PUBLIC_IP=$(curl -s icanhazip.com)
CURRENT_RECORD=$(dig @1.1.1.1 AAAA +short $RECORD_NAME)
RECORD_TYPE='AAAA'


data_json="{\"type\":\"$RECORD_TYPE\",\"name\":\"$RECORD_NAME\",\"content\":\"$PUBLIC_IP\"}"


if [[ $CURRENT_RECORD = $PUBLIC_IP ]]
then
        echo "IP was already up to date" | tee ~/cf-ddns/cf-ddns.log
        echo "$CURRENT_RECORD = DNS" | tee -a ~/cf-ddns/cf-ddns.log
        echo "$PUBLIC_IP = Public IP" | tee -a ~/cf-ddns/cf-ddns.log
else
        curl --request PUT \
          --url https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID \
          --header 'Content-Type: application/json' \
          --header "Authorization: Bearer $TOKEN" \
          --data $data_json
fi
