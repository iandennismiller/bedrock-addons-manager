# Minecraft Addon Manager 1.0

## Usage

```bash
mc.sh <enable|disable> <behavior|resource> <world_name> <addon_name>
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
