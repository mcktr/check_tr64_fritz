#!/bin/bash

HOSTNAME="fritz.box"
PORT="49443"
USERNAME="dslf-config"

while getopts h:p:u:P:U:s:a:x: OPTNAME; do
  case "${OPTNAME}" in
  h)
    HOSTNAME="${OPTARG}"
    ;;
  p)
    PORT="${OPTARG}"
    ;;
  u)
    USERNAME="${OPTARG}"
    ;;
  P)
    PASSWORD="${OPTARG}"
    ;;
  U)
    url="${OPTARG}"
    ;;
  s)
    service="${OPTARG}"
    ;;
  a)
    action="${OPTARG}"
    ;;
  x)
    xmlVar="${OPTARG}"
    ;;
  *)
    echo "fetch_tr64_data.sh -h <HOST> -p <PORT> -u <USER> -P <PASSWORD> -U <URL> -s <SERVICE> -a <ACTION> -x <xmlVar>"
    exit 0
    ;;
  esac
done

echo ""
echo ""
echo "${HOSTNAME}"
echo "${PORT}"
echo "${USERNAME}"
echo "${PASSWORD}"
echo "${url}"
echo "${service}"
echo "${action}"
echo "${xmlVar}"
echo ""
echo ""

queryResult=$(curl "https://${HOSTNAME}:${PORT}/upnp/control/${url}" \
-k \
-s \
-u ${USERNAME}:${PASSWORD} \
--anyauth \
-H "Content-Type: text/xml; charset='utf-8'" \
-H "SOAPACTION: urn:dslforum-org:service:${service}:1#${action}" \
-d "<?xml version='1.0'?> <s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/' s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'> <s:Body> <u:${action} xmlns:u='urn:dslforum-org:service:${service}:1'> ${xmlVar} </u:${action}> </s:Body> </s:Envelope>"
)

echo "${queryResult}"
