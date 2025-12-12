#!/usr/bin/env bash

dumps_dir='../macos-defaults'

while read domain; do
    # Usage: macos-defaults dump [OPTIONS] <--domain <DOMAIN>|--global-domain> [PATH]
    if macos-defaults dump --domain "$domain" "$dumps_dir/$domain-temporary.yaml"; then
        mv "$dumps_dir/$domain-temporary.yaml" "$dumps_dir/$domain.yaml"
    else
        echo "$domain" failed >&2
    fi
done < <(defaults domains | sed 's/, */\n/g')
