#!/bin/sh
export PICTHOR_UI_STATIC_FILES_DIR=/root/picthor-io-ui-dist
: "${PICTHOR_CACHE_DIR?PICTHOR_CACHE_DIR env var is required}"
: "${PICTHOR_SITE_URL?PICTHOR_SITE_URL env var is required}"
: "${PICTHOR_API_HOST?PICTHOR_API_HOST env var is required}"
mkdir $PICTHOR_CACHE_DIR
echo "{\"siteUrl\":\"$PICTHOR_SITE_URL\",\"apiHost\": \"$PICTHOR_API_HOST\"}" > $PICTHOR_UI_STATIC_FILES_DIR/env.json
java -jar /root/picthor.io.jar