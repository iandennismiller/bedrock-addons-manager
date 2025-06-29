# Installation

## Download

```bash
wget https://github.com/iandennismiller/bedrock-addons-manager/raw/refs/heads/main/mc.sh
```

## Install

To install, `chmod 755 mc.sh` and run it in the bedrock server data directory.

```bash
chmod 755 mc.sh
mv mc.sh /BEDROCK_SERVER_DATA_DIRECTORY
```

## Requirements

[jq](https://github.com/jqlang/jq) is required.
Many Linux distributions provide this by default.

## Access to mc.sh

Consider moving `mc.sh` to `/addons` (i.e. on the bedrock server) for convenient access - especially inside a Docker container.

## Next step: configuration

See [/docs/configure.md](/docs/configure.md) to configure the bedrock server and addons path.
