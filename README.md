<h1>
    <p align="center">
waybar-tailscale
</p>
</h1>
<p align="center">
A super simple module to manage <a href="https://tailscale.com/"><b>Tailscale</b></a> on <a href="https://github.com/Alexays/Waybar"><b>Waybar</b></a>.
</p>

<p align="center"><img src="https://github.com/federicovolponi/waybar-tailscale/blob/main/assets/vpn-on.png" alt="AppFlowy Kanban Board for To-dos"  /></p>

## ⭐️ What can it do?
- Show Tailscale status and your online and offline devices
- Toggle on/off the VPN
- Show and select an exit node
## Installation
Initially, you need to be able to use Tailscale without using `sudo`. You can do that by executing:
```bash
tailscale set --operator=$USER
```
After, you can clone the repository in your Waybar's configuration folder, or where you prefer.

## Configuration
In your _config_ file add a new module, as shown in the example below.
```json
"custom/tailscale" : {
    "exec": "~/.config/waybar/scripts/waybar-tailscale/waybar-tailscale.sh --status",
    "on-click": "exec ~/.config/waybar/scripts/waybar-tailscale/waybar-tailscale.sh --toggle",
    "on-click-right": "exec ~/.config/waybar/waybar-tailscale.sh --select-exit-node",
    "exec-on-event": true,
    "format": "VPN: {icon}",
    "format-icons": {
        "connected": "on",
        "stopped": "off"
    },
    "tooltip": true,
    "return-type": "json",
    "interval": 3,
}
```
**Important!** Be sure to insert the correct path to the script in the _exec_,  _on-click_, and _on-click-right_ fields.
The script is executed every three seconds, but you can easily change it by modifying the _interval_ field.

### Exit node

The `exit-node` can be included by changing the `format` key to:

```json
"format": "VPN: {icon}{text}",
```

### Exit Node Selection

You can use right-click to select an exit node. 
`wofi`  it's currently set to display the exit-node selection box, but you can update `MENU_CMD` in the script to any of the below based on what you have installed: 

```bash
wofi --dmenu --prompt 'Select Exit Node'
rofi -dmenu -p 'Select Exit Node'
fuzzel --dmenu --prompt 'Select Exit Node'
dmenu -p 'Select Exit Node'
```

### Colored tooltip

The status flag takes two optional parameters

```bash
waybar-tailscale.sh --status "#a6e22e" "#f92672"
```

The first is the color of active nodes, the second the color of inactive nodes. Defaults are respectively `green` and `red`.

### Adding IP to the tooltip
By default, no IP address will be shown in the tooltip. If you want to see the `ipv4` or `ipv6` addresses, pass one of the following arguments to the script:

```bash
waybar-tailscale.sh --status "#a6e22e" "#f92672" 'ipv4'
```

```bash
waybar-tailscale.sh --status "#a6e22e" "#f92672" 'ipv6'
```

```bash
waybar-tailscale.sh --status 'ipv6'
```

## Contributing
Even if this is a very trivial module, feel free to propose new features and point out any problems!
