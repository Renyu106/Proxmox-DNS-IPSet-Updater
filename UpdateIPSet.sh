#!/bin/bash

readonly DNS_SERVER="1.1.1.1"
readonly IPSET_NAME="servers"
readonly DNS_PREFIX="AutoDNS|"

IPSET_DATA=$(pvesh get /cluster/firewall/ipset/${IPSET_NAME} --output-format json)

echo "$IPSET_DATA" | jq -c '.[]' | while read -r item; do
    COMMENT=$(echo "$item" | jq -r '.comment')
    
    if [[ "$COMMENT" == ${DNS_PREFIX}* ]]; then
        CURRENT_IP=$(echo "$item" | jq -r '.cidr')
        
        DNS_NAME=${COMMENT#${DNS_PREFIX}}
        echo "Processing DNS: $DNS_NAME (Current IP: $CURRENT_IP)"
        
        NEW_IP=$(dig @$DNS_SERVER +short "$DNS_NAME" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)
        
        if [ -n "$NEW_IP" ]; then
            echo "Resolved IP: $NEW_IP"
            
            if [ "${CURRENT_IP%/*}" != "$NEW_IP" ]; then
                echo "IP changed for $DNS_NAME ($CURRENT_IP -> $NEW_IP)"
                
                echo "Removing old IP: $CURRENT_IP"
                pvesh delete "/cluster/firewall/ipset/${IPSET_NAME}/${CURRENT_IP}"
                
                echo "Adding new IP: $NEW_IP"
                pvesh create /cluster/firewall/ipset/${IPSET_NAME} -cidr "$NEW_IP/32" -comment "${DNS_PREFIX}$DNS_NAME"
            else
                echo "IP unchanged for $DNS_NAME"
            fi
        else
            echo "Failed to resolve DNS for $DNS_NAME"
        fi
    fi
done
