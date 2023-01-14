#!/bin/bash
## we.sh
## - get free unit usage from api-my.te.eg
## version 0.0.1
##################################################
file=~/.cache/we.json
phoneNumber=""
password=""
customerId=""
groupId=""
timestamp=$(date +%s)
locale="ar"
numberServiceType="FBB"
##################################################

generatetokenUrl=https://api-my.te.eg/api/user/generatetoken?channelId=WEB_APP
loginUrl=https://api-my.te.eg/api/user/login?channelId=WEB_APP
freeunitusageUrl=https://api-my.te.eg/api/line/freeunitusage
grouplevelUrl=https://api-my.te.eg/api/fmc/freeunitusage/grouplevel

##################################################
generatetoken() {
	generatedtoken=$(curl ${generatetokenUrl} -s -m 10 --compressed | jq -r ".body.jwt")
}

getJwt() {
	jwt=$(curl -s -m 10 ${loginUrl} \
		  -H 'Content-Type: application/json' \
		  -H "Jwt: $generatedtoken" \
		  --data-raw '{"header":{"msisdn":"'"$phoneNumber"'","numberServiceType":"'"$numberServiceType"'","timestamp":"'"$timestamp"'","locale":"'"$locale"'"},"body":{"password":"'"$password"'"}}' \
		  --compressed | jq -r ".body.jwt")
}

getData() {
	data=$(curl -s -m 10 ${freeunitusageUrl} \
		  -H 'Content-Type: application/json' \
		  -H "Jwt: $jwt" \
		  --data-raw '{"header":{"customerId":"'"$customerId"'","msisdn":"'"$phoneNumber"'","numberServiceType":"'"$numberServiceType"'","locale":"'"$locale"'"}}' \
		  --compressed)
	type=0
	writeData
}

getGroupData() {
	data=$(curl -s -m 10 ${grouplevelUrl} \
		  -H 'Content-Type: application/json' \
		  -H "Jwt: $jwt" \
		  --data-raw '{"header":{"customerId":"'"$customerId"'","msisdn":"'"$phoneNumber"'","numberServiceType":"'"$numberServiceType"'","locale":"'"$locale"'"},"body":{"groupId":"'"$groupId"'","numberServiceType":"FBB"}}' \
		  --compressed)
	type=4
	writeData
}

writeData() {
	if (( $(jq -r ".body.detailedLineUsageList  | length" <<< "$data") > 0 ))
	then
		echo $data > $file
		echo -e "$(jq ".body.detailedLineUsageList[$type].usagePercentage" <<< "$data")%"
	else
		echo "Can't get data!"
		exit 0
	fi
}

generatetoken && getJwt && getGroupData
##################################################
