#!/bin/bash
echo "              _  __                 _                   _"
echo " _____      _(_)/ _|_ __   ___   __| | ___   _ __   ___| |_"
echo "/ __\\ \\ /\\ / / | |_| '_ \\ / _ \ / _\` |/ _ \\ | '_ \\ / _ \\ __|"
echo "\\__ \\\\ V  V /| |  _| | | | (_) | (_| |  __/_| | | |  __/ |_"
echo "|___/ \\_/\\_/ |_|_| |_| |_|\\___/ \\__,_|\\___(_)_| |_|\\___|\\__|"
INTERFACE="$(cat ./settings.ini | grep 'interface' | awk '{print $3}' | tr -d '\011\012\013\014\015\040\042' | tr -d ';')"
tcpdump -B 4096 -n --dont-verify-checksums -i ${INTERFACE} | ./netbps.pl
