#!/bin/sh

if [ -z "$1" ]; then 
echo "No output path specified"
exit 1;
fi


PROJECT_ID="$INPUT_OVERLEAF_PROJECT_ID"
ZIP_OUTPUT_PATH="${1}/main.zip"
EXTRACTED_FILES_PATH="./artifacts/"
COOKIE="$INPUT_OVERLEAF_COOKIE"

echo "Dumping zip file at $ZIP_OUTPUT_PATH"

curl "https://tex.elashri.xyz/project/$PROJECT_ID/download/zip" \
  -H 'authority: tex.elashri.xyz' \
  -H 'pragma: no-cache' \
  -H 'cache-control: no-cache' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H "$COOKIE" \
  --output "$ZIP_OUTPUT_PATH" --create-dirs

echo "Extracting all files at $EXTRACTED_FILES_PATH"

unzip -o "$ZIP_OUTPUT_PATH" -d "$EXTRACTED_FILES_PATH"
