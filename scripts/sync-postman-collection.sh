#!/bin/sh

set -e

version="1.0.0"
name="Postman Echo v$version - openapi"
openapi_yaml="./openapi/postman-echo-oas-v$version.yaml"
collection_json="./openapi/postman-echo-postman-v$version.json"

openapi2postmanv2 -s $openapi_yaml -o $collection_json -p

collection_id=$(postmanctl get collection -o jsonpath="{[?(@.name=='$name')].id}")

if [ -z $collection_id ]
then
  collection_id=$(cat $collection_json | postmanctl create collection)
  echo "$collection_id created in Postman!"
else
  collection_id=$(cat $collection_json | postmanctl replace collection $collection_id)
  echo "$collection_id updated in Postman!"
fi
