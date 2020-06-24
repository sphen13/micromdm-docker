#!/bin/sh

# we are going to assume that the following is true:
#   APNS_CERT = mdm_push_cert.pem
#   APNS_KEY = ProviderPrivateKey.key
# we are going to require the following ENV variables:
#   APNS_PASSWORD
#   SERVER_URL
# the following are optional:
#   TLS_CERT (if using custom ssl certs)
#   TLS_KEY (if using custom ssl certs)
#   API_KEY
#   COMMAND_WEBHOOK_URL
#   NO_COMMAND_HISTORY
#   USE_DYNAMIC_CHALLENGE
#   GEN_DYNAMIC_CHALLENGE
#   DEBUG

# local directories we are going to work with are:
#   /config
#   /certs
#   /repo

# peform quick checks:
if [[ -z ${SERVER_URL} ]]; then
  echo "Please set the 'SERVER_URL' environment variable."
  exit 1
fi

runMicroMDM="micromdm serve \
  -server-url='${SERVER_URL}' \
  -filerepo /repo \
  -config-path /config"

# add api key if specified
if [[ ${API_KEY} ]]; then
  runMicroMDM="${runMicroMDM} \
    -api-key ${API_KEY}"
fi

# process TLS settings
if [[ ${TLS} ]]; then
  if [[ ${TLS_CERT} ]] && [[ ${TLS_KEY} ]] && [[ -f "/certs/${TLS_CERT}" ]] && [[ -f "/certs/${TLS_KEY}" ]]; then
    runMicroMDM="${runMicroMDM} \
      -tls-cert '/certs/${TLS_CERT}' \
      -tls-key '/certs/${TLS_KEY}'"
  fi
else
  runMicroMDM="${runMicroMDM} \
    -tls=false"
fi

# process webhook
if [[ ${COMMAND_WEBHOOK_URL} ]]; then
  runMicroMDM="${runMicroMDM} \
    -command-webhook-url ${COMMAND_WEBHOOK_URL}"
fi

# process no-command-history
if [[ ${NO_COMMAND_HISTORY} ]]; then
  runMicroMDM="${runMicroMDM} \
    -no-command-history=${NO_COMMAND_HISTORY}"
fi

# process use-dynamic-challenge
if [[ ${USE_DYNAMIC_CHALLENGE} ]]; then
  runMicroMDM="${runMicroMDM} \
    -use-dynamic-challenge=${USE_DYNAMIC_CHALLENGE}"
fi

# process gen-dynamic-challenge
if [[ ${GEN_DYNAMIC_CHALLENGE} ]]; then
  runMicroMDM="${runMicroMDM} \
    -gen-dynamic-challenge=${GEN_DYNAMIC_CHALLENGE}"
fi

# process debugging
if [[ ${DEBUG} ]]; then
  runMicroMDM="${runMicroMDM} \
    -http-debug"
  echo "$runMicroMDM"
fi

#run
eval $runMicroMDM
