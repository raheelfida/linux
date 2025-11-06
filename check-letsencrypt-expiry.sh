#!/bin/bash
# Script: check-letsencrypt-expiry.sh
# Purpose: List Let's Encrypt certificates and their expiry dates

CERT_DIR="/etc/letsencrypt/live"

echo "---------------------------------------------"
echo " Let's Encrypt Certificate Expiry Checker"
echo "---------------------------------------------"

if [ ! -d "$CERT_DIR" ]; then
    echo "Directory $CERT_DIR not found!"
    exit 1
fi

for DOMAIN in $(ls "$CERT_DIR"); do
    CERT_FILE="$CERT_DIR/$DOMAIN/fullchain.pem"
    if [ -f "$CERT_FILE" ]; then
        EXPIRY_DATE=$(openssl x509 -in "$CERT_FILE" -noout -enddate | cut -d= -f2)
        echo "Domain: $DOMAIN"
        echo "Expires on: $EXPIRY_DATE"
        echo "---------------------------------------------"
    fi
done
