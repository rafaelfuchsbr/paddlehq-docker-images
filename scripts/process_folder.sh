#!/bin/bash

export FOLDER="$1"
cd ${FOLDER}

if [ -f "${MANIFEST_FILE}" ]
then
  eval "${ROOT_FOLDER}/scripts/build_image.sh"
else
  echo "File '${MANIFEST_FILE}' not found for '${FOLDER}'."
fi

cd ${ROOT_FOLDER}
echo ""
