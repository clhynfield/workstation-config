#!/usr/bin/env bash

# set -x

dumps_dir='../macos-defaults'

while read domain; do
    if defaults export "$domain" "$dumps_dir/$domain-temporary.plist"; then
        mv "$dumps_dir/$domain-temporary.plist" "$dumps_dir/$domain.plist"
    else
        echo "Exporting $domain failed" >&2
    fi
done < <(defaults domains | sed 's/, */\n/g')

cd "$dumps_dir"

plutil -remove lastSeenBatteryInfosV2 com.apple.AudioAccessory.plist
plutil -remove AccountInfoValidationCounter com.apple.CloudKit.plist

for plist_file in *.plist; do
    if plutil -type CloudKitAccountInfoCache "$plist_file" >/dev/null 2>&1; then
        plutil -remove CloudKitAccountInfoCache "$plist_file"
    fi
    if plutil -convert xml1 -e xml "$plist_file"; then
        rm "$plist_file"
        true
    else
        echo "Converting $domain failed"
    fi
done
