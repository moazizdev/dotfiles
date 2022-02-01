#!/usr/bin/env bash

declare -A CURRENCIES

CURRENCIES=(
    ["دولار امريكى - USD"]="USD"
    ["يورو - EUR"]="EUR"
    ["جنية استرلينى"]="GBP"
    ["ريال سعودى"]="SAR"
    ["دينار كويتي"]="KWD"
    ["درهم إمراتى"]="AED"
    ["دينار بحريني"]="BHD"
    ["ريال عماني"]="OMR"
    ["ريال قطري"]="QAR"
)

# egcurancy api URL
URL="https://egcurancyapi.herokuapp.com/v1/currency"


all_banks_short_name(){
    currency="$1"
    results="$(
        curl -s "$URL/$currency" 2>/dev/null -m 5
    )" || echo 'no results'
    
    # printf "\t\t\t\t\t%s\n" "$currency"

    # sort_by(.sell) | reverse
    # to sort depending on sell column 
    printf "%s\n" "$results" | jq -r 'sort_by(.sell) | .[] | "[\(.bank)]|[\(.buy)]|[\(.sell)]\t|\t[\(.updated_at | strftime("%d/%m/%Y"))][\(.updated_at | strflocaltime("%I:%M%p"))]"' |\
    column -s '|' -t
}

# Rofi dmenu
rofi_dmenu(){
    rofi -dmenu -l 22 -matching fuzzy -no-custom -p "Banks | buy($currency) | sell($currency) | date | time"
    # -location 0 -bg "#F8F8FF" -fg "#000000" -hlbg "#ECECEC" -hlfg "#0366d6"
}

# List for rofi
gen_list() {
    for i in "${!CURRENCIES[@]}"
    do
        echo "$i"
    done
}

main() {
    # Pass the list to rofi
    currency=$( (gen_list) | rofi -dmenu -sort -matching fuzzy -no-custom -location 0 -p "Currency > " )
    
    if [[ -n "$currency" ]]; then
        selected_currency=${CURRENCIES[$currency]}
        repository=$(all_banks_short_name $selected_currency | rofi_dmenu )
    else
        exit
    fi
}

main

exit 0
