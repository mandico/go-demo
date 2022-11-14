#!/bin/sh

host=""

if [ "$1" = "PRD" ]; then
  host="domain.com"
elif [ "$1" = "STAGE" ]; then
  host="stage.domain.com"
else
  echo "*** Provide PRD or STAGE as parameter ***"
  exit 1
fi

while(true); do
  curl --header "Host: $host" http://localhost:80/demo/info
  echo ""
  sleep 1
done