#!/usr/bin/env bash

STATUS_KEY="BackendState"
RUNNING="Running"

tailscale_status () {
    status="$(tailscale status --json | jq -r '.'$STATUS_KEY)"
    if [ "$status" = $RUNNING ]; then
        return 0
    fi
    return 1
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
            #TODO: find a way to format output
            peers=$(echo "$(tailscale status)" | tr -d '\n')
            echo "{\"text\":\"\",\"class\":\"connected\",\"alt\":\"connected\", \"tooltip\": \"\n$peers\"}"
        else
            echo "{\"text\":\"\",\"class\":\"stopped\",\"alt\":\"stopped\", \"tooltip\": \"The VPN is not active.\"}"
        fi
    ;;
    --toggle)
        toggle_status
    ;;
esac


