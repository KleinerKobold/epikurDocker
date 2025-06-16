#!/bin/bash

# URL der Webseite
URL="https://www.epikur.de/service/testversion/"

# HTML-Inhalt abrufen
html=$(curl -s "$URL")

# Link zur .deb-Datei extrahieren
deb_link=$(echo "$html" | grep -oP 'https://[^"]*/epikur4Server-[0-9]+(\.[0-9]+)*-all\.deb')
# Ergebnis prüfen und ausgeben
if [[ -n "$deb_link" ]]; then
    echo "Gefundener Link: $deb_link"
else
    echo "Kein passender Link gefunden."
fi
