#!/bin/sh

# check vars are set
: "${PICTHOR_WEB_ADDRESS?PICTHOR_WEB_ADDRESS env var is required}"
: "${PICTHOR_POSTGRES_HOST?PICTHOR_POSTGRES_HOST env var is required}"
: "${PICTHOR_POSTGRES_PORT?PICTHOR_POSTGRES_PORT env var is required}"
: "${PICTHOR_POSTGRES_USERNAME?PICTHOR_POSTGRES_USERNAME env var is required}"
: "${PICTHOR_POSTGRES_PASSWORD?PICTHOR_POSTGRES_PASSWORD env var is required}"
: "${PICTHOR_POSTGRES_DB?PICTHOR_POSTGRES_DB env var is required}"

# build postgres jdbs url
export PICTHOR_POSTGRES_JDBC_URL="jdbc:postgresql://$PICTHOR_POSTGRES_HOST:$PICTHOR_POSTGRES_PORT/$PICTHOR_POSTGRES_DB"
# build allowed cors origins
export PICTHOR_CORS_ORIGINS="$PICTHOR_WEB_ADDRESS"
# trim trailing slashes
export PICTHOR_WEB_ADDRESS=$(echo $PICTHOR_WEB_ADDRESS | sed 's:/*$::')

mkdir -p $PICTHOR_CACHE_DIR

export PICTHOR_UI_STATIC_FILES_DIR=/root/picthor-io-ui-dist

# build UI app env file
echo "{\"siteUrl\":\"$PICTHOR_WEB_ADDRESS\",\"apiHost\": \"$PICTHOR_WEB_ADDRESS\"}" > $PICTHOR_UI_STATIC_FILES_DIR/env.json
java -jar /root/picthor.io.jar