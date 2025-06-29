function show_help() {
    echo "Minecraft Bedrock Addons Manager 1.0"
    echo
    echo "Usage:"
    echo "\$ $(basename $0) <enable|disable> <behavior|resource> <addon_name> <world_name>"
    echo
    echo "Example: enable an addon called 'Some Addon 1.2' for a world called 'My Cool World'"
    echo "1. Unzip the addon, then split into resource and/or behavior packs."
    echo "2. Move the behavior pack to ADDONS_PATH/behavior_packs/some-addon-1.2"
    echo "3. Move the resource pack to ADDONS_PATH/resource_packs/some-addon-1.2"
    echo "4. Finally enable the addon for a world called 'My Cool World'"
    echo "\$ $(basename $0) enable resource 'some-addon-1.2' 'My Cool World'"
    echo "\$ $(basename $0) enable behavior 'some-addon-1.2' 'My Cool World'"
    echo
    echo "DATA_PATH:        $DATA_PATH"
    echo "ADDONS_PATH:      $ADDONS_PATH"
    echo
    echo "Worlds path:      $DATA_PATH/worlds"
    echo "Behavior packs:   $ADDONS_PATH/behavior_packs"
    echo "Resource packs:   $ADDONS_PATH/resource_packs"

    exit 1
}
