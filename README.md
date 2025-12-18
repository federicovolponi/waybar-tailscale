# waybar-tailscale
![VPN](https://github.com/federicovolponi/waybar-tailscale/blob/main/assets/vpnonoff.png)

A super simple module to show and toggle the status of [Tailscale](https://tailscale.com/) on [Waybar](https://github.com/Alexays/Waybar).
## Installation
At first, you need to be able to use tailscale without using `sudo`. You can do that by executing:
```bash
tailscale set --operator=$USER
```
After, you can simply clone the repository in your waybar's configuration folder, or where you prefer.
## Configuration
In your _config_ file add a new module as the example below.
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
**Important!** Be sure to insert the correct path to the script in the _exec_ and _on-click_ fields.
The script is executed every three seconds, but you can easily change it by modifying the _interval_ field.

### Exit node

`exit-node` can be included by changing the `format` key to:

```json
"format": "VPN: {icon} exit-node: {text}",
```

### Exit Node Selection

You can use right-click to select a exit node, its currently set to use `wofi` to display the exit-node selection box but you can update `MENU_CMD` to any of the below based on what you have installed. 

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

The first being the color of active nodes, the second the color of inactive nodes. defaults are respectively `green` and `red`.

## Contributing
Even if this is a very trivial module, requests for new features and any issues you might find are welcomed.
