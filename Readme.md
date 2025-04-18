# Minecraft Bedrock Addons Manager 1.0

Manage addons for Minecraft Bedrock Server and the worlds they host.

https://github.com/iandennismiller/bedrock-addons-manager

This bash script simplifies the task of enabling/disabling addons for worlds hosted on Minecraft Bedrock Server.
If you use Docker to run Minecraft Bedrock Server from a Linux image (e.g. [itzg/minecraft-bedrock-server](https://github.com/itzg/minecraft-bedrock-server)), then this script will probably *just work*.

The most useful thing this script does is to copy the UUID from addons `manifest.json` and place it in the correct JSON files in your worlds.
(That is the technical explanation for how Minecraft Bedrock Server actually puts addons *into* worlds.)

## Installation

[jq](https://github.com/jqlang/jq) is required. Many Linux distributions provide this by default.

To install, just `chmod 755 mc.sh` and run it in the bedrock server data directory.

## Usage

```bash
./mc.sh <enable|disable> <behavior|resource> <addon_name> <world_name>
```

This real-world example enables the `camouflage-doors` addon for `my-cool-world`.

```bash
./mc.sh enable resource camouflage-doors my-cool-world
```

To use this script, put resource packs in `/addons/resource_packs` and behavior packs in `/addons/behavior_packs`.
If you have `Some Addon 0.2 by cooldude.mcpack` file, unzip that file and figure out if it contains a resource pack, a behavior pack, or both.
For example, if it is a resource pack, put the unzipped contents into a new folder called `/addons/resource_packs/some-addon-0.2`.

The environment variables `ADDONS_PATH` and `DATA_PATH` control where `mc.sh` will look for files.
One way to use a custom value is:

```bash
ADDONS_PATH=/other-addons-folder ./mc.sh ...
```

Consider moving `mc.sh` to `/addons` for convenient access inside a Docker container.

### Directory structure

After unpacking some behavior packs and resource packs to the addons folder, it should look like this:

```bash
# find /addons -maxdepth 2 | sort
/addons
/addons/behavior_packs
/addons/behavior_packs/better-on-bedrock-1.21.40
/addons/behavior_packs/better-on-bedrock-1.21.50
/addons/behavior_packs/camouflage-doors
/addons/behavior_packs/furnideco-remake
/addons/behavior_packs/instant-structures
/addons/behavior_packs/more-simple-structures
/addons/behavior_packs/more-tools
/addons/behavior_packs/mr-cray-fish-furniture
/addons/behavior_packs/security-cameras
/addons/behavior_packs/simple-waystone
/addons/mc.sh
/addons/resource_packs
/addons/resource_packs/better-on-bedrock-1.21.40
/addons/resource_packs/better-on-bedrock-1.21.50
/addons/resource_packs/camouflage-doors
/addons/resource_packs/crop-redstone
/addons/resource_packs/furnideco-remake
/addons/resource_packs/instant-structures
/addons/resource_packs/luminous-dreams
/addons/resource_packs/more-simple-structures
/addons/resource_packs/more-tools
/addons/resource_packs/mr-cray-fish-furniture
/addons/resource_packs/security-cameras
/addons/resource_packs/simple-waystone
```

For reference, your bedrock server directory should look like this.
You will need to run `mc.sh` inside this directory.

```bash
# find /data -maxdepth 1 | sort
/data
/data/Dedicated_Server.txt
/data/allowlist.json
/data/backup-pre-1.21.60.10
/data/backup-pre-1.21.71.01
/data/bedrock_server-1.21.71.01
/data/bedrock_server_how_to.html
/data/behavior_packs
/data/config
/data/definitions
/data/development_behavior_packs
/data/development_resource_packs
/data/development_skin_packs
/data/minecraftpe
/data/permissions.json
/data/premium_cache
/data/profanity_filter.wlist
/data/release-notes.txt
/data/resource_packs
/data/resource_packs.bak
/data/restify.err
/data/server.properties
/data/treatments
/data/world_templates
/data/worlds
/data/worlds.bak
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

Copy `mc.sh` to `/addons` and invoke it inside the minecraft bedrock server container.

The following example adds [camouflage-doors](https://www.curseforge.com/minecraft-bedrock/addons/camouflage-door-addon) to a world called `my-cool-world` which is served from the docker container called `minecraft-red`.

```bash
docker exec -it minecraft-red /addons/mc.sh enable resource camouflage-doors my-cool-world
```
