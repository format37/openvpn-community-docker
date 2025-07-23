#!/bin/bash

# Usage: ./sendfile.sh <file-path> [caption]

file_path="$1"
caption="${2:-Here is your file}"

# Your bot token and user chat ID:
bot_token="BOT_TOKEN"
chat_id="USER_ID"

if [[ ! -f "$file_path" ]]; then
    echo "File not found: $file_path"
    exit 1
fi

curl -s -X POST "https://api.telegram.org/bot$bot_token/sendDocument" \
  -F chat_id="$chat_id" \
  -F document=@"$file_path" \
  -F caption="$caption" \
  -F parse_mode="HTML"
