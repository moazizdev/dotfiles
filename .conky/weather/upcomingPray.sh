#!/bin/bash

#

# tools required
JQ=`which jq`

if [[ -z "${JQ}" ]]; then
  echo "ERROR: jq is not installed."
  exit -1
fi

while getopts t:n: flag
do
    case "${flag}" in
        t) option=${OPTARG};;
        n) option=${OPTARG};;
    esac
done

# set cache and config file
if [[ -z "${CONFIG}" ]]; then
  CONFIG="config.json"
fi

CACHE_DIR=${CACHE_DIR:-$(cat ${CONFIG} | jq '.upcoming_prayer.cache_dir' -r)}
Fetch_EVERY_MINUTE=${Fetch_EVERY_MINUTE:-$(cat ${CONFIG} | jq '.upcoming_prayer.fetch_every_minute' -r)}
CITY=${City:-$(cat ${CONFIG} | jq '.upcoming_prayer.city' -r)}
SCHOOL=${School:-$(cat ${CONFIG} | jq '.upcoming_prayer.school' -r)}
JURISTIC=${Juristic:-$(cat ${CONFIG} | jq '.upcoming_prayer.juristic' -r)}
TIMEFORMAT=${Timeformat:-$(cat ${CONFIG} | jq '.upcoming_prayer.timeformat' -r)}

function get_cache_path() {
  echo ${CACHE_DIR}/upcoming_prayer.json
}

#######################################
# Check the cache file and determine
# if it needs to be updated or not
# Returns:
#   0 or 1
#######################################
function cache_needs_refresh() {
  cache_path=$(get_cache_path)
  now=$(date +%s)

  # if the cache does not exist, refresh it
  if [[ ! -f "${cache_path}" ]]; then
    return 1
  fi

  last_modification_date=$(stat -c %Y ${cache_path})
  seconds=$(expr ${now} - ${last_modification_date})
  interval=$((${Fetch_EVERY_MINUTE} * 60))
  if [[ "${seconds}" -gt ${interval} ]]; then
    return 1
  else
    return 0
  fi
}

function fetch_pray() {
  cache_needs_refresh
  refresh=$?
  cache_path=$(get_cache_path)

  if [[ ! -f "${cache_path}" ]] || [[ "${refresh}" -eq 1 ]]; then
    command=`curl -s https://api.pray.zone/v2/times/today.json?city=${CITY}\&school=${SCHOOL}\&juristic=${JURISTIC}\&timeformat=${TIMEFORMAT}`
    echo "$command" > ${cache_path}.$$
    # only update the file if we successfully retrieved the JSON
    num_of_lines=$(cat "${cache_path}.$$" | wc -c) #print the byte count of the file
    if [[ "${num_of_lines}" -gt 5 ]]; then
      mv "${cache_path}.$$" ${cache_path}
    else
      rm -f ${cache_path}.$$
    fi
  fi
}

function create_cache() {
  if [[ ! -d "${CACHE_DIR}" ]]; then
    mkdir -p ${CACHE_DIR}
  fi
}

function getNextPrayer {
    #get current datetime in seconds
    now=$(date +%s)
    cache_path=$(get_cache_path)
    #Those variables will store the next prayer and its index

    #Loop through prayer time and get next one
    json=$(cat $(get_cache_path) | jq -r '.results.datetime[].times')
    arr=['Sunrise','Sunset','Midnight','Imsak']
    jq -r 'to_entries | map(.key + "|" + (.value | tostring)) | .[]' <<<"$json" | \
        while IFS='|' read key value; do  
          if [[ $(date +%s -d "$value") > $now && !( ${arr[*]} =~ "$key" ) ]]; then
              echo "$key in" $(( ( $(date +%s -d "$value") - $now ) / 60 / 60 )) "hr" $(( ( $(date +%s -d "$value") - $now ) / 60 - ( $(date +%s -d "$value") - $now ) / 60 / 60 * 60  )) "min";
              break
          fi
        done
}

# PROGRAM LOGIC ================================================================
# Parse options ----------------------------------------------------------------
while getopts ":vh:" opt; do
  case $opt in
    h) mode="help"; break ;;
    v) mode="version"; break ;;
  esac
done

case $mode in
  help)
    echo "usage"
    exit
    ;;
  version)
    echo "prayer $version"
    exit
    ;;
esac

create_cache
fetch_pray
getNextPrayer
