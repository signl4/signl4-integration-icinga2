#!/usr/bin/env bash

# Format:
# ./signl4-service-notification.sh URL https://connect.signl4.com/webhook/<team-secret> Param1 Value1 Param2 Value2 [etc.]
# Edit your SIGNL4 hook URL and use your own team secret
SIGNL4_URL=$2

SIGNL4_MSG="{"
for ((i = 3; i <= $#-2; i=$i+2 )); do
  SIGNL4_MSG+="\"${!i}\": "
  ((j=i+1))
  SIGNL4_MSG+="\"${!j}\""

  # External Id
  if [[ "${!i}" == "ExternalIdHost" ]]
  then
	SIGNL4_MSG+=", \"X-S4-ExternalId\": \"Icinga Host: ${!j}\""
  fi
  if [[ "${!i}" == "ExternalIdService" ]]
  then
	SIGNL4_MSG+=", \"X-S4-ExternalId\": \"Icinga Service: ${!j}\""
  fi

  # Check for resolved state
  shopt -s nocasematch; if [[ "${!i}" == "Type" && "${!j}" == "Recovery" ]]
  then
	SIGNL4_MSG+=", \"X-S4-Status\": \"resolved\""
  fi

  # Check for acknowledged state
  shopt -s nocasematch; if [[ "${!i}" == "Type" && "${!j}" == "Acknowledgement" ]]
  then
	SIGNL4_MSG+=", \"X-S4-Status\": \"acknowledged\""
  fi

  # Check for problem state
  shopt -s nocasematch; if [[ "${!i}" == "Type" && "${!j}" == "Problem" ]]
  then
	SIGNL4_MSG+=", \"X-S4-Status\": \"new\""
  fi

  # Source System
  SIGNL4_MSG+=", \"X-S4-SourceSystem\": \"Icinga\""

  if (($i < $#))
  then
	SIGNL4_MSG+=", "
  fi
done
SIGNL4_MSG="$SIGNL4_MSG }\""

#SIGNL4_MSG="{ \"$1\": \"$2\" }"

#SIGNL4_MSG="{ \"Title\": \"Service $1 notification\", \"Host\": \"$2\", \"IP\": \"$3\", \"Service\": \"$4\", \"State\": \"$5\", \"Additional Info\":\"$6\", \"Nagios notification\": \"$7\", \"X-S4-Service\": \"Nagios\"  }"

#Send message to SIGNL4
curl -L -X POST -H "Content-type: application/json" --data "$SIGNL4_MSG" $SIGNL4_URL
