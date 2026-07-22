<h1>
    <p align="center">
waybar-tailscale
</p>
</h1>
<p align="center">
A super simple module to manage <a href="https://tailscale.com/"><b>Tailscale</b></a> on <a href="https://github.com/Alexays/Waybar"><b>Waybar</b></a>.
</p>

<p align="center"><img src="https://github.com/federicovolponi/waybar-tailscale/blob/main/assets/vpn-on.png" alt="waybar-tailscale"  /></p>
## ⭐️ What can it do?

- Show Tailscale status and your online and offline devices
- Shows Current version and available updates
- Toggle on/off the VPN
- Show and select an exit node

## Installation

Initially, you need to be able to use Tailscale without using `sudo`. You can do that by executing:

```bash
tailscale set --operator=$USER
```

After, you can clone the repository in your Waybar's configuration folder, or where you prefer.

## Configuration

In your waybar `config.json` add a new module, as shown in the example below.

```json
"custom/tailscale" : {
    "exec": "~/.config/waybar/waybar-tailscale/waybar-tailscale.sh --status 'ipv4'",
    "on-click": "exec ~/.config/waybar/waybar-tailscale/waybar-tailscale.sh --toggle",
    "on-click-right": "exec ~/.config/waybar/waybar-tailscale/waybar-tailscale.sh --select-exit-node",
    "exec-on-event": true,
    "format": "         ",
    // uncomment if you want icons, don't use with tailscale.css
    // "format": "VPN {icon}",
    // "format-icons": {
    //     "connected": "󱠾 󰕥 ",
    //     "stopped": "󱠾  "
    // },
    "tooltip": true,
    "return-type": "json",
    "interval": 1,
},
```

**Important!** Be sure to insert the correct path to the script in the _exec_,  _on-click_, and _on-click-right_ fields.
The script is executed every second, but you can easily change it by modifying the _interval_ field.

If you want the tailscale-logo (and not icons) add the next line on top of your waybar `style.css` (don't use with "format-icons" in waybar `config.json`)

```
@import "waybar-tailscale/tailscale.css";
```

### Exit node

The `exit-node` can be included by changing the `format` key to:

```json
"format": "VPN: {icon}{text}",
```

### Exit Node Selection

You can use right-click to select an exit node.
`walker`  it's currently set to display the exit-node selection box, but you can update `MENU_CMD` in the script to any of the below based on what you have installed:

```bash
walker --dmenu 'Select Exit Node'
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

### Showing the Tailscale version

By default, the tooltip does not show your Tailscale version. If you want to see the installed version and whether it is up to date with the latest release, pass the `version` argument:

```bash
waybar-tailscale.sh --status "#a6e22e" "#f92672" 'ipv4' 'version'
```

Checking the latest release requires a network request, so the result is cached for `VERSION_CHECK_TTL` seconds (default `3600`, one hour) to avoid hitting the network on every poll. You can change this at the top of `waybar-tailscale.sh`, or set it to `0` to check on every run instead.

When an update is available, the module also returns an extra `update-available` class and `alt` value alongside `connected`, so you can show a distinct icon for it. If you're using `format-icons`, add an `update-available` key as shown in `sample-config`. If you're using `tailscale.css`, it already ships with a `.update-available` rule that tints the icon.

### Checking if auto-update is enabled

Tailscale can update itself automatically. To show whether that's enabled on this machine, pass the `autoupdate` argument:

```bash
waybar-tailscale.sh --status "#a6e22e" "#f92672" 'ipv4' 'autoupdate'
```

If auto-update is explicitly disabled, the module returns an extra `auto-update-disabled` class and `alt` value, the same way it does for `update-available`. If auto-update isn't supported or configured on this machine, the tooltip just says so with no icon change. Add an `auto-update-disabled` key to `format-icons`, or use the `.auto-update-disabled` rule already in `tailscale.css`, to show a distinct icon.

## Contributing

Even if this is a very trivial module, feel free to propose new features and point out any problems!
