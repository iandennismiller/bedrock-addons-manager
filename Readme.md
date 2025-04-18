# Minecraft Bedrock Addons Manager 1.0

Manage addons for Minecraft Bedrock Server and the worlds they host.

https://github.com/iandennismiller/bedrock-addons-manager

This bash script simplifies the task of enabling/disabling addons for worlds hosted on Minecraft Bedrock Server.
If you use Docker to run Minecraft Bedrock Server from a Linux image (e.g. [itzg/minecraft-bedrock-server](https://github.com/itzg/minecraft-bedrock-server)), then this script will probably *just work*.

The most useful thing this script does is to copy the UUID from addons `manifest.json` and place it in the correct JSON files in your worlds.
(That is the technical explanation for how Minecraft Bedrock Server actually puts addons *into* worlds.)

## Installation

[jq](https://github.com/jqlang/jq) is required. Many Linux distributions provide this by default.

To install, just `chmod 755 mc.sh` and run it on the command line with `./mc.sh` or `bash mc.sh`.

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

After unpacking some behavior packs and resource packs, it should look like this:

```bash
# cd /addons && find . -maxdepth 2
.
./mc.sh
./behavior_packs
./behavior_packs/security-cameras
./behavior_packs/furnideco-remake
./behavior_packs/better-on-bedrock-1.21.50
./behavior_packs/more-simple-structures
./behavior_packs/camouflage-doors
./behavior_packs/better-on-bedrock-1.21.40
./behavior_packs/more-tools
./behavior_packs/instant-structures
./behavior_packs/simple-waystone
./behavior_packs/mr-cray-fish-furniture
./resource_packs
./resource_packs/security-cameras
./resource_packs/furnideco-remake
./resource_packs/crop-redstone
./resource_packs/better-on-bedrock-1.21.50
./resource_packs/more-simple-structures
./resource_packs/camouflage-doors
./resource_packs/luminous-dreams
./resource_packs/better-on-bedrock-1.21.40
./resource_packs/more-tools
./resource_packs/instant-structures
./resource_packs/simple-waystone
./resource_packs/mr-cray-fish-furniture
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
