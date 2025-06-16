#!/bin/bash

# Ziel-URL der Webseite
PAGE_URL="https://www.epikur.de/service/testversion/"

# HTML-Inhalt abrufen
html=$(curl -s "$PAGE_URL")

# Aktuellen Link zur .deb-Datei extrahieren
deb_link=$(echo "$html" | grep -oP 'https://[^"]*/epikur4Server-[0-9]+(\.[0-9]+)*-all\.deb' | head -n 1)

# Prüfen, ob ein Link gefunden wurde
if [[ -z "$deb_link" ]]; then
    echo "❌ Kein gültiger .deb-Link gefunden."
    exit 1
fi

# Dateiname extrahieren
deb_file=$(basename "$deb_link")
build_needed=false

# Prüfen, ob die Datei existiert
if [[ ! -f "$deb_file" ]]; then
    echo "📥 Datei '$deb_file' wird heruntergeladen..."
    wget "$deb_link" -O "$deb_file" || {
        echo "❌ Download fehlgeschlagen."
        exit 1
    }
    build_needed=true
else
    echo "✅ Datei '$deb_file' ist bereits vorhanden."

    # Prüfen, ob das Docker-Image existiert
    if docker image inspect epikur:latest > /dev/null 2>&1; then
        # Alter des Docker-Images prüfen (in Stunden)
        created=$(docker image inspect epikur:latest --format='{{.Created}}')
        created_ts=$(date -d "$created" +%s)
        now_ts=$(date +%s)
        age_hours=$(( (now_ts - created_ts) / 3600 ))

        echo "ℹ️ Docker-Image ist $age_hours Stunden alt."

        if [[ "$age_hours" -gt 48 ]]; then
            echo "🔁 Docker-Image ist älter als 72 Stunden – wird neu gebaut."
            build_needed=true
        else
            echo "⏳ Docker-Image ist aktuell – kein Build notwendig."
        fi
    else
        echo "⚠️ Docker-Image existiert nicht – wird gebaut."
        build_needed=true
    fi
fi

# Docker-Image bauen, wenn nötig
if [[ "$build_needed" = true ]]; then
    
    echo "🚧 Docker-Image wird gebaut..."
    echo "Dynamisches Dockerfile erzeugen"
    sed "s/%DEB_FILE%/$deb_file/g" Dockerfile.template > Dockerfile

    # Heutiges Datum als Tag
    today_tag=$(date +%Y-%m-%d)
    image_tag="epikur:$today_tag"


    docker build --pull --rm -f "Dockerfile" -t epikur:latest -t "$image_tag" "." || {
        echo "❌ Docker-Build fehlgeschlagen."
        exit 1
    }
    echo "EPIKUR_IMAGE=$image_tag" > .env_tag
    echo "✅ Docker-Image erfolgreich gebaut."
fi
