#!/bin/bash

# OpenVPN Client Certificate Generator
# Usage: ./generate_client.sh <client_name>

set -e  # Exit on any error

# Check if client name is provided
if [ $# -eq 0 ]; then
    echo "Error: Client name is required"
    echo "Usage: $0 <client_name>"
    echo "Example: $0 alex_mobile"
    exit 1
fi

CLIENT_NAME="$1"

# Validate client name (basic validation - alphanumeric and underscores only)
if [[ ! "$CLIENT_NAME" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "Error: Client name should contain only alphanumeric characters and underscores"
    exit 1
fi

echo "Generating OpenVPN client certificate for: $CLIENT_NAME"
echo "=========================================="

# Step 1: Build client certificate (interactive - requires passphrase)
echo "Step 1: Building client certificate..."
echo "Note: You will be prompted for the CA passphrase"
sudo docker run -v ovpn-data:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full "$CLIENT_NAME" nopass

# Check if the previous command succeeded
if [ $? -eq 0 ]; then
    echo "✓ Client certificate built successfully"
else
    echo "✗ Failed to build client certificate"
    exit 1
fi

# Step 2: Generate client configuration file
echo ""
echo "Step 2: Generating client configuration file..."
sudo docker run -v ovpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient "$CLIENT_NAME" > "${CLIENT_NAME}.ovpn"

# Check if the configuration file was created
if [ -f "${CLIENT_NAME}.ovpn" ]; then
    echo "✓ Client configuration generated: ${CLIENT_NAME}.ovpn"
    echo ""
    echo "Client setup complete!"
    echo "Configuration file: ${CLIENT_NAME}.ovpn"
    echo "You can now transfer this file to your client device."
else
    echo "✗ Failed to generate client configuration file"
    exit 1
fi
