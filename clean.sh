#!/bin/bash

# Aktuelles Datum in Sekunden
now=$(date +%s)

# Durchsuche alle epikur:<Tag> Images mit Datum
docker images --format '{{.Repository}}:{{.Tag}} {{.CreatedSince}}' | \
grep '^epikur:' | \
grep -Ev 'latest|<none>' | \
while read -r line; do
    image=$(echo "$line" | awk '{print $1}')
    created=$(docker image inspect "$image" --format='{{.Created}}')
    created_ts=$(date -d "$created" +%s)

    age_days=$(( (now - created_ts) / 86400 ))

    if (( age_days > 5 )); then
        echo "🗑️  Lösche altes Image: $image ($age_days Tage alt)"
        docker rmi "$image"
    fi
done
