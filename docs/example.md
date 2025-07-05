# Examples

```bash
mc.sh $ACTION $ADDON_TYPE $ADDON_NAME $WORLD_NAME
```

- ACTION may be `enable` or `disable`
- ADDON_NAME is the folder name of the addon
- WORLD_NAME is the folder name world on the server

## Quick usage

This real-world example enables the `camouflage-doors` addon for `my-cool-world`.

```bash
mc.sh enable resource my-cool-world camouflage-doors
```

## Full example, including installation

Enable an addon called 'Some Addon 1.2' for a world called 'My Cool World'

1. Unzip the addon, then split into resource and/or behavior packs.
2. Move the behavior pack to ADDONS_PATH/behavior_packs/some-addon-1.2
3. Move the resource pack to ADDONS_PATH/resource_packs/some-addon-1.2
4. Finally enable the addon for a world called 'My Cool World'

```bash
mc.sh enable 'My Cool World' 'some-addon-1.2'
```

## Different addons path

The environment variables `ADDONS_PATH` and `DATA_PATH` control where `mc.sh` will look for files.
One way to use a custom value is:

```bash
ADDONS_PATH=/other-addons-folder mc.sh ...
```
