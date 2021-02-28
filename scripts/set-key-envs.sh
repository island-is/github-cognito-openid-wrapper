#!/bin/bash -eu
. "$PWD"/scripts/lib-robust-bash.sh # load the robust bash library

PROJECT_ROOT="$PWD" # Figure out where the project directory is

require_binary ssh-keygen
require_binary openssl

KEY_FILE="$PROJECT_ROOT"/jwtRS256.key
KEY_FILE_PUB="$PROJECT_ROOT"/jwtRS256.key.pub

if [ ! -f "$KEY_FILE" ]; then
  echo "  --- Creating private key, as it does not exist ---"
  ssh-keygen -t rsa -b 4096 -m PEM -f "$KEY_FILE" -N ''
else
  echo " --- Private key found, skipping ...."
fi

echo "  --- Create .pub from .key file ---"
openssl rsa -in "$KEY_FILE" -pubout -outform PEM -out "$KEY_FILE_PUB"

JWT_RSA_KEY=$(cat "$KEY_FILE")
JWT_RSA_PUB=$(cat "$KEY_FILE_PUB")
export JWT_RSA_KEY=$JWT_RSA_KEY
export JWT_RSA_PUB=$JWT_RSA_PUB

# rm -- "$KEY_FILE" "$KEY_FILE_PUB"