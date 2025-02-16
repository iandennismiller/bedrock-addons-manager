# Minecraft Addon Manager 1.0

Manage addons for Minecraft Bedrock servers and the worlds they host.

This bash script simplifies the task of enabling/disabling addons for worlds on Minecraft Bedrock servers.
All resource packs and behavior packs are stored in `/addons/resource_packs` and `/addons/behavior_packs` - each in its own subdirectory.
This script is a quick way to link these addons to servers and worlds.

The most useful thing this script does is to copy the UUID from addons and place it in the correct JSON files in your worlds.

## Installation

[jq](https://github.com/jqlang/jq) is required.

To install, just `chmod 755 mc.sh` and run it.

## Usage

```bash
mc.sh <enable|disable> <behavior|resource> <addon_name> <world_name>
```

To use a custom ADDONS_PATH or DATA_PATH:

```bash
ADDONS_PATH=/somewhere mc.sh <enable|disable> <behavior|resource> <addon_name> <world_name>
```

## Example

Enable an addon called 'Some Addon 1.2' for a world called 'My Cool World'

1. Unzip the addon, then split into resource and/or behavior packs.
2. Move the behavior pack to ADDONS_PATH/behavior_packs/some-addon-1.2
3. Move the resource pack to ADDONS_PATH/resource_packs/some-addon-1.2
4. Finally enable the addon for a world called 'My Cool World'

```bash
mc.sh enable resource 'some-addon-1.2' 'My Cool World'
mc.sh enable behavior 'some-addon-1.2' 'My Cool World'
```

