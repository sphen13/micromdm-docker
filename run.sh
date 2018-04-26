#!/bin/sh

# we are going to require the following ENV variables:
#   APNS_PASSWORD
#   SERVER_URL
# the following are optional:
#   TLS_CERT (if using custom ssl certs)
#   TLS_KEY (if using custom ssl certs)
#   API_KEY
#   DEBUG

# local directories we are going to work with are:
#   /config
#   /certs
#   /repo

# Set Environmental VARS.

APNS_CERT="${APNS_CERT:-'/certs/mdm_push_cert.pem'}"
APNS_PASSWORD="${APNS_PASSWORD}"
APNS_KEY="${APNS_KEY:-'/certs/ProviderPrivateKey.key'}"
TLS_CERT="${TLS_CERT:-'/certs/tls.pem'}"
TLS_KEY="${TLS_KEY:-'/certs/tls.key'}"
FILE_REPO="${REPO:-'/repo'}"
CONFIG_PATH="${CONFIG_PATH:-'/config'}"
SERVER_URL="${SERVER_URL}"

# Perform Quick Check.

if [[ ! -e "${APNS_CERT}" ]]; then
  echo "Please map a valid '/certs/mdm_push_cert.pem' to the container."
  exit 1
fi
if [[ -z ${SERVER_URL} ]]; then
  echo "Please set the 'SERVER_URL' environment variable."
  exit 1
fi

runMicroMDM="micromdm serve \
  -apns-cert ${APNS_CERT} \
  -apns-key ${APNS_KEY} \
  -server-url ${SERVER_URL} \
  -filerepo ${FILE_REPO} \
  -config-path $CONFIG_PATH"

# APNS Password is not required if using a P12 cert so making this optional
if [[ ${APNS_PASSWORD} ]]; then
  runMicroMDM="${runMicroMDM} \
    -apns-password ${APNS_PASSWORD}"
fi

# add api key if specified
if [[ ${API_KEY} ]]; then
  runMicroMDM="${runMicroMDM} \
    -api-key ${API_KEY}"
fi

# process TLS settings
if [[ ${TLS} == true ]]; then
  if [[ ! -z "${TLS_CERT}" && ! -z ${TLS_KEY} && -e "${TLS_CERT}" && -e "${TLS_KEY}" ]]; then
    runMicroMDM="${runMicroMDM} \
      -tls-cert '${TLS_CERT}' \
      -tls-key '${TLS_KEY}'"
  fi
else
  runMicroMDM="${runMicroMDM} \
    -tls=false"
fi

# process debugging
if [[ ${DEBUG} ]]; then
  runMicroMDM="${runMicroMDM} \
    -http-debug"
fi

#echo "$runMicroMDM"

#run
eval "${runMicroMDM}"
