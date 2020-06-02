#!/bin/sh

set -e

workspace_name="My Workspace"
api_name="Postman Echo"
version="1.0.0"
openapi_yaml="./openapi/postman-echo-oas-v$version.yaml"

workspace_id=$(postmanctl get workspaces -o jsonpath="{[?(@.name=='$workspace_name')].id}")
api_id=$(postmanctl get api --workspace=$workspace_id -o jsonpath="{[?(@.name=='$api_name')].id}")

if [ -z $api_id ]
then
  api_id=$(echo '{"name":"'"$api_name"'"}' | postmanctl create api --workspace=$workspace_id)
  echo "API $api_id created in Postman!"
fi

api_version_id=$(postmanctl get api-version --for-api $api_id -o jsonpath="{[?(@.name=='$version')].id}")

if [ -z $api_version_id ]
then
  api_version_id=$(echo '{"name":"'"$version"'","api":"'"$api_id"'"}' | postmanctl create api-version --for-api=$api_id --workspace=$workspace_id)
  echo "API Version $api_version_id created in Postman!"
fi

schema_id=$(postmanctl get api-version --for-api=$api_id $api_version_id -o jsonpath="{[].schema[0]}" 2>/dev/null)

tmpfile=$(mktemp)
node -p '`{"language":"yaml","type":"openapi3","schema":${JSON.stringify(require("fs").readFileSync("'$openapi_yaml'", "utf8"))}}`' > $tmpfile

if [ -z $schema_id ]
then
  schema_id=$(postmanctl create schema --for-api=$api_id --for-api-version=$api_version_id --filename $tmpfile)
  echo "Schema $schema_id created in Postman!"
else
  schema_id=$(postmanctl replace schema --for-api=$api_id --for-api-version=$api_version_id $schema_id --filename $tmpfile)
  echo "Schema $schema_id updated in Postman!"
fi
