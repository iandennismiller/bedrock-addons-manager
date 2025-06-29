# Configure your bedrock server

To use this script, put resource packs in `/addons/resource_packs` and behavior packs in `/addons/behavior_packs`.
If you have `Some Addon 0.2 by cooldude.mcpack` file, unzip that file and figure out if it contains a resource pack, a behavior pack, or both.
For example, if it is a resource pack, put the unzipped contents into a new folder called `/addons/resource_packs/some-addon-0.2`.

## Addons directoey

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

## Bedrock server directory

Your bedrock server directory should look like this.
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
