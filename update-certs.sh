#!/bin/sh
# This is github.com/miklosbagi/ca-init-container
# Single function to handle all errors
e() { echo "Error: $1"; exit 1; }
# Copy self-signed *_ca.crt files to pickup dir
cp /certs/*_ca.crt /usr/local/share/ca-certificates/ || e "Failed to copy *_ca.crt files"
# Update CA Certificates
update-ca-certificates || e "Failed to update CA Certificates"
# Copy updated certificates to shared volume (should be mapped to docker volume)
cp -prf /etc/ssl/* /output-certs/ || e "Failed to copy updated certificates to shared volume"
# Leave a note that this is auto-generated
rm -f /output-certs/generated-by-cainit-*
touch /output-certs/generated-by-cainit-$(date +%Y%m%d-%H%M%S) || e "Failed to leave a note about auto-ganaeration"
# Kthxbye
echo "Certificates updated. Exiting."
exit 0
