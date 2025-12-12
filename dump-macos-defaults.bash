#!/usr/bin/env bash

while read domain; do
    if defaults read "$domain" > ".temporary.plist" 2>/dev/null; then
        mv ".temporary.plist" "${domain}.plist"
    else
        echo "$domain" failed
    fi
done < <(defaults domains | sed 's/, */\n/g')
