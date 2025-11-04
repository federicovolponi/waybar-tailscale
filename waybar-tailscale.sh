#!/usr/bin/env bash

tailscale_status () {
    return "$(tailscale status --json | jq -r '.BackendState | if . == "Running" then 0 else 1 end')"
}

toggle_status () {
    if tailscale_status; then
        tailscale down
    else
        tailscale up
    fi
    sleep 5
}

case $1 in
    --status)
        if tailscale_status; then
            T=${2:-"green"}
            F=${3:-"red"}

            peers=$(tailscale status --json | jq -r --arg T "'$T'" --arg F "'$F'" '.Peer[]? | ("<span color=" + (if .Online then $T else $F end) + ">" + (.DNSName | split(".")[0]) + "</span>")' | tr '\n' '\r')
            exitnode=$(tailscale status --json | jq -r '.Peer[]? | select(.ExitNode == true).DNSName | split(".")[0]')
            echo "{\"text\":\"${exitnode}\",\"class\":\"connected\",\"alt\":\"connected\", \"tooltip\": \"${peers}\"}"
        else
            echo "{\"text\":\"\",\"class\":\"stopped\",\"alt\":\"stopped\", \"tooltip\": \"The VPN is not active.\"}"
        fi
    ;;
    --toggle)
        toggle_status
    ;;
esac


