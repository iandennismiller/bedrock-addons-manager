# Minecraft Bedrock Addons Manager

Manage addons for Minecraft Bedrock Server.

https://github.com/iandennismiller/bedrock-addons-manager

## About

This bash script enables/disables addons for worlds hosted on Minecraft Bedrock Server.
In technical terms, `mc.sh` copies the UUID from addons `manifest.json` into a world's JSON files.

## Quick Start

### Install

```bash
wget https://github.com/iandennismiller/bedrock-addons-manager/raw/refs/heads/main/mc.sh
chmod 755 mc.sh
```

For more about installation, see [/docs/install.md](/docs/install.md).

For notes about how to configure and organize the bedrock server so `mc.sh` can use it, see [/docs/configure.md](/docs/configure.md).

### Usage

Once mc.sh is installed and the bedrock server is configured, run it like this:

```bash
mc.sh $ACTION $ADDON_TYPE $ADDON_NAME $WORLD_NAME
```

- ACTION may be `enable` or `disable`
- ADDON_TYPE may be `behavior` or `resource`
- ADDON_NAME is the folder name of the addon
- WORLD_NAME is the folder name world on the server

This real-world example enables the `camouflage-doors` addon for `my-cool-world`.

```bash
mc.sh enable resource camouflage-doors my-cool-world
mc.sh enable behavior camouflage-doors my-cool-world
```

For more usage examples, see [/docs/example.md](/docs/example.md).

### Docker

If you use Docker to run Minecraft Bedrock Server from a Linux image (e.g. [itzg/minecraft-bedrock-server](https://github.com/itzg/minecraft-bedrock-server)), then this script will probably *just work*.

See [/docs/docker.md](/docs/docker.md) for notes about running `mc.sh` inside a docker container.
