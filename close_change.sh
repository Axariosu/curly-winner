#!/bin/bash -e

# variable definition
snow_instance="dev128938.service-now.com"
username="api_snow_btp.gen"
password="mXJebMRrtdTgig_jV2JY"
client_id="7bef99d9b6311110197440bd8eeb70f4"
client_secret="[B||4Eg\$5b"

# get ServiceNOW token
response_json=$(curl -s --location --request POST https://${snow_instance}/oauth_token.do \
    --header "content-type:application/x-www-form-urlencoded" \
    --data-urlencode grant_type="password" \
    --data-urlencode username=${username} \
    --data-urlencode password=${password} \
    --data-urlencode client_id=${client_id} \
    --data-urlencode client_secret=${client_secret})

# sed -e 's/[{}]/''/g'      // removes parentheses
# sed s/\"//g               // removes double quotes
# gets access token from json key-value pair
access_token=$(echo ${response_json} | sed -e 's/[{}]/''/g' | sed s/\"//g | awk -v RS=',' -F: '$1=="access_token"{print $2}')
echo ${access_token}

snow_request_id="a4f56b6547f1111004a29128436d4334"

# get example 
# response_json=$(curl -v -s --location --request GET https://${snow_instance}/api/now/table/change_request/${snow_request_id} \
#     --header "Accept: application/json" \
#     --header "Content-Type: application/json" \
#     --header "Authorization: Bearer ${access_token}")

# implement change, '{"state":"-1"}'
response_json=$(curl -v -s --location --request PUT https://${snow_instance}/api/now/table/change_request/${snow_request_id} \
    --header "Accept: application/json" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer ${access_token}" \
    --data '{"state":"-1"}')
echo ${response_json}


response_json=$(curl -v -s --location --request PUT https://${snow_instance}/api/now/table/change_request/${snow_request_id} \
    --header "Accept: application/json" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer ${access_token}" \
    --data '{
    "state": "3",
    "close_code": "Successful with issues",
    "close_notes": "The change is implemented successfully without any issues"
    }')
echo ${response_json}

# If the previous command "$?" was successful, then 
# if [ $? -eq 0 ] 
# then 
#     $(curl -v -s --location --request PUT https://${snow_instance}/api/now/table/change_request/${snow_request_id} \
#     --header "Accept: application/json" \
#     --header "Content-Type: application/json" \
#     --header "Authorization: Bearer ${access_token}" \
#     --data '{
#     "work_notes": "Add new notes by table API"
#     }')
# fi