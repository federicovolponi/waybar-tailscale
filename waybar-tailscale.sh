#!/usr/bin/env bash

MENU_CMD="wofi --dmenu --prompt 'Select Exit Node'"  # Change to rofi/fuzzel/dmenu as needed

tailscale_status() {
    tailscale status --json | jq -r '.BackendState == "Running"' | grep -q true
}

toggle_status() {
    if tailscale_status; then
        tailscale down
    else
        tailscale up
    fi
    sleep 5
}

select_exit_node() {
    if ! tailscale_status; then
        notify-send "Tailscale" "VPN is not running"
        return 1
    fi

    # Get available exit nodes (devices that advertise as exit nodes)
    local nodes
    nodes=$(tailscale status --json | jq -r '
        .Peer[] | select(.ExitNodeOption == true) |
        .DNSName | split(".")[0]
    ')

    # Add option to disable exit node
    nodes="None (disable exit node)"$'\n'"$nodes"

    # Show menu and get selection
    local selected
    selected=$(echo "$nodes" | $MENU_CMD)

    [ -z "$selected" ] && return 0  # User cancelled

    if [[ "$selected" == "None"* ]]; then
        tailscale set --exit-node=
        notify-send "Tailscale" "Exit node disabled"
    else
        tailscale set --exit-node="$selected"
        notify-send "Tailscale" "Exit node set to: $selected"
    fi
}

case $1 in
    --status)
        if tailscale_status; then
            T=${2:-"green"}
            F=${3:-"red"}
            peers=$(tailscale status --json | jq -r --arg T "'$T'" --arg F "'$F'" '.Peer[]? | ("<span color=" + (if .Online then $T else $F end) + ">" + (.DNSName | split(".")[0]) + "</span>")' | tr '\n' '\r')
            exitnode=$(tailscale status --json | jq -r '.Peer[]? | select(.ExitNode == true).DNSName | split(".")[0]')
            echo "{\"text\":\"${exitnode:-none}\",\"class\":\"connected\",\"alt\":\"connected\", \"tooltip\": \"${peers}\"}"
        else
            echo "{\"text\":\"\",\"class\":\"stopped\",\"alt\":\"stopped\", \"tooltip\": \"The VPN is not active.\"}"
        fi
    ;;
    --toggle)
        toggle_status
    ;;
    --select-exit-node)
        select_exit_node
    ;;
esac
