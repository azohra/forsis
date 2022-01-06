#!/usr/bin/env bash

# This script builds the fastlane-plugin-forsis gem and pushes it to rubygems.org"

GEM_NAME="fastlane-plugin-forsis"
RUBYGEMS_API_KEY="$1"

# HOME is a default environment variable provided by Github Actions
mkdir -p "$HOME"/.gem
touch "$HOME"/.gem/credentials
chmod 0600 "$HOME"/.gem/credentials
printf -- "---\n:rubygems_api_key: ${RUBYGEMS_API_KEY}\n" > "$HOME"/.gem/credentials

GEM_FILE_NAME=$(gem build $GEM_NAME.gemspec | awk '/File/ {print $2}')

if [[ -z $GEM_FILE_NAME ]]; then
    printf "%b" "\e[31m ERROR: Invalid gem file.\n\e[39m"
    exit 1
fi

if gem push "$GEM_FILE_NAME"; then
    printf "%b" "\e[32m Gem published successfully.\n\e[39m"
else
    printf "%b" "\e[31m ERROR: RubyGems Deployment Failed.\n\e[39m"
    exit 1
fi
