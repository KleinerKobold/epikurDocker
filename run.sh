#!/bin/bash

# .env_tag zusätzlich zur normalen .env einlesen
set -o allexport
[ -f .env ] && source .env
[ -f .env_tag ] && source .env_tag
set +o allexport

docker compose up -d