#!/bin/sh

set -e

version="1.0.0"

openapi2postmanv2 -s ./openapi/postman-echo-oas-v$version.yaml -o ./openapi/postman-echo-postman-v$version.json

collection_id=$(postmanctl get collection -o jsonpath="{[?(@.name=='Postman Echo v$version - openapi')].id}")

if [ -z $collection_id ]
then
  collection_id=$(cat ./openapi/postman-echo-postman-v$version.json | postmanctl create collection)
  echo "$collection_id created in Postman!"
else
  collection_id=$(cat ./openapi/postman-echo-postman-v$version.json | postmanctl replace collection $collection_id)
  echo "$collection_id updated in Postman!"
fi
