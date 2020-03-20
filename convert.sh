#!/bin/sh
set -x
npm install
ls -1 ./oas2/*.yml | while read swagger; do
  # use '$item'
  echo "${swagger}"
  oapi_output="$(echo "$(basename "${swagger}")" | cut -d'.' -f1)"
  echo "${oapi_output}"
  # npx api-spec-converter --from=swagger_2 --to=openapi_3 --syntax=yaml "${swagger}" > "./oas3/${oapi_output}.oas3.yaml"
  npx swagger2openapi --patch -y "${swagger}" -o "./oas3/${oapi_output}.oas3.yaml"
  # NOTE: above, consider swagger2openapi options --resolveInternal --resolve
done
