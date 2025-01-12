# waybar-tailscale
![VPN](https://github.com/federicovolponi/waybar-tailscale/blob/main/assets/vpnonoff.png)

A super simple module to show and toggle the status of [Tailscale](https://tailscale.com/) on [Waybar](https://github.com/Alexays/Waybar).
## Installation
At first, you need to be able to use tailscale without using `sudo`. You can do that by executing:
```
tailscale set --operator=$USER 
```
After, you can simply clone the repository in your waybar's configuration folder, or where you prefer.
## Configuration
In your _config_ file add a new module as the example below.
```
"custom/tailscale" : {
    "exec": "~/.config/waybar/scripts/waybar-tailscale/waybar-tailscale.sh --status",
    "on-click": "exec ~/.config/waybar/scripts/waybar-tailscale/waybar-tailscale.sh --toggle",
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

## Contributing
Even if this is a very trivial module, requests for new features and any issues you might find are welcomed.
