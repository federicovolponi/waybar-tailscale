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
            T="green"
            F="red"
            I="none"
            colors=()

            for arg in "${@:2}"; do
                case "$arg" in
                    ipv4|ipv6) 
                        I="$arg" 
                        ;;
                    *) 
                        if [[ -n "$arg" ]]; then
                            colors+=("$arg")
                        fi
                        ;;
                esac
            done

            if [ ${#colors[@]} -ge 1 ]; then T="${colors[0]}"; fi
            if [ ${#colors[@]} -ge 2 ]; then F="${colors[1]}"; fi

            status_json=$(tailscale status --json)

            case "$I" in
                ipv4) ip_idx="0" ;;
                ipv6) ip_idx="-1" ;;
                *)    ip_idx="" ;;
            esac

            if [[ -n "$ip_idx" ]]; then
                peers=$(jq -r --arg T "$T" --arg F "$F" --arg idx "$ip_idx" '
                    .Peer[]? | 
                    "<span color=\"" + (if .Online then $T else $F end) + "\">" + 
                    (.DNSName | split(".")[0]) + " (" + .TailscaleIPs[$idx|tonumber] + ")</span>"
                ' <<< "$status_json" | tr '\n' '\r')
            else
                peers=$(jq -r --arg T "$T" --arg F "$F" '
                    .Peer[]? | 
                    "<span color=\"" + (if .Online then $T else $F end) + "\">" + 
                    (.DNSName | split(".")[0]) + "</span>"
                ' <<< "$status_json" | tr '\n' '\r')
            fi

            exitnode=$(jq -r '.Peer[]? | select(.ExitNode == true).DNSName | split(".")[0]' <<< "$status_json")

            jq -nc --arg txt "${exitnode:-none}" --arg tip "$peers" \
                '{"text": $txt, "class": "connected", "alt": "connected", "tooltip": $tip}'
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
