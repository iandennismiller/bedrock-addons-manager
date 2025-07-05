function show_config() {
    echo "ADDONS_PATH: $1"
    echo "DATA_PATH: $2"
    echo "WORLD_NAME: $3"
    echo "ADDON_NAME: $4"
    echo "ADDON_TYPE: $5"
    echo "MANIFEST_PATH: $6"
    echo "WORLD_JSON: $7"
    echo "ADDON_UUID: $8"
    echo "ADDON_VERSION: $9"
}

function show_help() {
    echo "Bedrock Addons Manager"
    echo "https://github.com/iandennismiller/bedrock-addons-manager"
    echo
    echo "Usage:"
    echo
    echo "mc.sh ACTION [WORLD_NAME] [ADDON_NAME]"
    echo
    echo "Action is required, and can be one of the following:"
    echo
    echo "  enable WORLD ADDON   Enable an addon for a world"
    echo "  disable WORLD ADDON  Disable an addon for a world"
    echo "  list WORLD           List enabled addons for a world"
    echo "  list-all             List all available addons"
    echo "  help                 Show this help message"
    echo
}

function show_example() {
    echo "Example: enable an addon called 'Some Addon 1.2' for a world called 'My Cool World'"
    echo "1. Unzip the addon, then split into resource and/or behavior packs."
    echo "2. Move the behavior pack to ADDONS_PATH/behavior_packs/some-addon-1.2"
    echo "3. Move the resource pack to ADDONS_PATH/resource_packs/some-addon-1.2"
    echo "4. Finally enable the addon for a world called 'My Cool World'"
    echo "mc.sh enable 'My Cool World' 'some-addon-1.2'"
}
