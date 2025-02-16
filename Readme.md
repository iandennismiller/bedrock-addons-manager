# Minecraft Bedrock Addons Manager 1.0

Manage addons for Minecraft Bedrock Server and the worlds they host.

https://github.com/iandennismiller/bedrock-addons-manager

This bash script simplifies the task of enabling/disabling addons for worlds hosted on Minecraft Bedrock Server.
If you use Docker to run Minecraft Bedrock Server from a Linux image (e.g. [itzg/minecraft-bedrock-server](https://github.com/itzg/minecraft-bedrock-server)), then this script will probably *just work*.

The most useful thing this script does is to copy the UUID from addons `manifest.json` and place it in the correct JSON files in your worlds.
(That is the technical explanation for how Minecraft Bedrock Server actually puts addons *into* worlds.)

## Installation

[jq](https://github.com/jqlang/jq) is required. Many Linux distributions provide this by default.

To install, just `chmod 755 mc.sh` and run it.

## Usage

```bash
mc.sh <enable|disable> <behavior|resource> <addon_name> <world_name>
```

To use this script, put resource packs in `/addons/resource_packs` and behavior packs in `/addons/behavior_packs`.
If you have `Some Addon 0.2 by cooldude.mcpack` file, unzip that file and figure out if it contains a resource pack, a behavior pack, or both.
For example, if it is a resource pack, put the unzipped contents into a new folder called `/addons/resource_packs/some-addon-0.2`.

Consider moving `mc.sh` to `/addons` for convenience.

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

## Docker example with itzg/minecraft-bedrock-server

I use [itzg/minecraft-bedrock-server](https://github.com/itzg/minecraft-bedrock-server) to run Minecraft Bedrock.

In the following example, I demonstrate using `/data` and `/addons` for a live server.

```bash
docker run --rm \
    --name minecraft \
    -e EULA=TRUE \
    -p 19132:19132/udp \
    -p 19132:19132/tcp \
    -v minecraft-data:/data \
    -v minecraft-addons:/addons \
    itzg/minecraft-bedrock-server
```

Copy `mc.sh` to `/addons` and invoke it inside the minecraft bedrock server container:

```bash
docker exec -it minecraft /addons/mc.sh enable some-addon-1.2 my-cool-world
```
