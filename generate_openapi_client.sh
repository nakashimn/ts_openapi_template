#! /bin/bash
npx openapi-generator-cli generate \
    -i ./app/openapi/root.yaml \
    -g dart \
    -o ./interface/openapi_dart/

npx openapi-generator-cli generate \
    -i ./app/openapi/root.yaml \
    -g typescript \
    -o ./interface/openapi_ts/

npx openapi-generator-cli generate \
    -i ./app/openapi/root.yaml \
    -g python \
    -o ./interface/openapi_python/
